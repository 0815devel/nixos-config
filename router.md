# Boot

```nix
{
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = false;
    "net.ipv4.conf.all.arp_filter" = 1;
    "net.ipv4.conf.default.arp_filter" = 1;
  };
}
```

# Interfaces and Networking

```nix
{
  networking = {
    hostName = "router";
    domain = "internal";
    useDHCP = false;
    nftables.enable = true;
    firewall.enable = false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    links = {
      "lan" = {
        matchConfig = {
          MACAddress = "aa:aa:aa:aa:aa:00";
        };
        linkConfig = {
          Name = "lan";
        };
      };
      "wan" = {
        matchConfig = {
          MACAddress = "aa:aa:aa:aa:aa:03";
        };
        linkConfig = {
          Name = "wan";
        };
      };
  };
  networks = {
    "lan" = {
      linkConfig.RequiredForOnline = "yes";
      matchConfig.Name = "lan";
      address = [ "10.0.0.1/24" ];
      dns = [ "127.0.0.1" "1.1.1.1" ];
      domains = [ "internal" ];
    };
    "wan" = {
      matchConfig.Name = "wan";
      linkConfig.Unmanaged = "yes";
      linkConfig.RequiredForOnline = "no";
    };
  };
}
```

# PPPoE

```nix
{
  services.pppd = {
    enable = true;
    peers."inexio" = {
      autostart = true;
      enable = true;
      config = ''
        plugin rp-pppoe.so wan
        name "<USERNAME>"
        noipdefault
        hide-password
        lcp-echo-interval 20
        lcp-echo-failure 3
        noauth
        persist
        maxfail 0
        holdoff 30
        mtu 1492
        mru 1492
        noaccomp
        noproxyarp
        default-asyncmap
        noipv6
        nodefaultroute
        noreplacedefaultroute
        ifname pppoe0
      '';
    };
  };
}
```

# dnsmasq

```nix
{
  service.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      interface = "lan";
      bind-interfaces = true;
      listen-address = [ "127.0.0.1" "10.0.0.1" ];
      
      server = [ "1.1.1.1" ];
      no-resolv = true;
      cache-size = 10000;
    
      dhcp-range = [ "10.0.0.127,10.0.0.254,255.255.255.0,24h" ];
      dhcp-authoritative = true;
        
      dhcp-option = [
        "option:router,10.0.0.1"
        "option:dns-server,10.0.0.1"
      ];
    
      domain = "internal";
      expand-hosts = true;
      local = "/internal/";
      domain-needed = true;
    
      dhcp-host = [
        "00:11:22:33:44:55,10.0.0.10,pcname"
        "AA:BB:CC:DD:EE:FF,10.0.0.11,server"
      ];
    };
  };
}
```

# Firewall

```nix
{
  networking.nftables.ruleset = ''
    flush ruleset  # Clear existing rules

    define LAN = "lan"
    define WAN = "pppoe0"

    ##########################
    # Filter table
    ##########################
    table inet filter {

      # OUTPUT chain - handle outcoming traffic
      chain output {
        type filter hook output priority 0;
        # Default accept
        policy accept;
      }

      # INPUT chain - handle incoming traffic
      chain input {
        type filter hook input priority 0;

        # Default drop
        policy drop;                           

        # Allow loopback
        iifname lo accept;

        # Allow established connections    
        ct state established,related accept;

        # Allow Ping
        icmp type echo-request accept;

        # MSS Clamping                                                  
        icmp type { destination-unreachable, time-exceeded, parameter-problem } accept;

        # Allow all traffic from LAN
        iifname $LAN accept;

        # Allow Wireguard from WAN                                            
        iifname $WAN udp dport 51820 accept;   
      }

      # FORWARD chain - handle routed traffic
      chain forward {
        type filter hook forward priority 0;

        # Default drop
        policy drop;

        # MSS Clamping                                             
        tcp flags syn tcp option maxseg size set rt mtu                 

        # Allow LAN -> WAN
        iifname $LAN oifname $WAN accept;

        # Allow WAN -> LAN responses                       
        iifname $WAN oifname $LAN ct state established,related accept;

        # Allow LAN internal traffic
        iifname $LAN oifname $LAN accept;

        # Allow DNAT
        iifname $WAN ip daddr 10.0.0.2 tcp dport { 80, 443 } accept;      
      }
    }

    ##########################
    # NAT table
    ##########################
    table ip nat {

      # PREROUTING - port forwarding from WAN
      chain prerouting {
        type nat hook prerouting priority 0;

        # WAN port 80 -> LAN host 80
        tcp dport 80 iifname $WAN dnat to 10.0.0.2:80;

        # WAN port 443 -> LAN host 443       
        tcp dport 443 iifname $WAN dnat to 10.0.0.2:443;     
      }

      # POSTROUTING - masquerade LAN -> WAN
      chain postrouting {
        type nat hook postrouting priority 100;

        # Masquerade outgoing WAN traffic
        oifname $WAN masquerade;                            
      }
    }
  '';
}
```

# WireGuard

```nix
{
  networking.wireguard = {
    enable = true;
    interfaces = {
      "wg0" = {
        privateKeyFile = "/etc/wireguard/private.key";
        listenPort = 51820;
        ips = [ "10.10.0.1/24" ];
        peers = {
          "a" = {
            presharedKeyFile = "/etc/wireguard/preshared.key";
            publicKey = "PUBLIC_KEY";
            allowedIPs = [ "10.10.0.2/32" ];
          };
          "b" = {
            presharedKeyFile = "/etc/wireguard/preshared.key";
            publicKey = "PUBLIC_KEY";
            allowedIPs = [ "10.10.0.3/32" ];
          };
        };
      };
    };
  };
}
```

# ddclient

```nix
{
  services.ddclient = {
    enable = true;
    interval = 300;
    ssl = true;
    usev4 = "if, if=pppoe0";
    protocol = "cloudflare";
    zone = "example.com";
    passwordFile = "/run/secrets/ddclient-password";
    domains = [ "example.com" ];
  };
}
```

# CrowdSec

## Router
```nix
services.crowdsec = {
  enable = true;
  settings = {
    api.server = {
      listen_addr = "10.0.0.1";
      port = 8080;
    };
    parsers.whitelist = {
      reason = "Exclude local network and trustworthy IPs";
      ip = [ "127.0.0.1" ];
      cidr = [ "10.0.0.0/24" "10.10.0.0/24" ];
  };
  };
};

services.crowdsec-firewall-bouncer = {
  enable = true;
  api_url = "http://10.0.0.1:8080";
  api_key = "key";
};
```

## Caddy
```nix
services.crowdsec = {
  enable = true;
  settings = {
    api.client.urls = [ "http://10.0.0.1:8080" ];
    acquisition_files = [ "/var/log/caddy/access.log" ];
  };
};
```
