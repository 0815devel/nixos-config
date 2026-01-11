# Boot

```nix
{ config, lib, pkgs, ... }:

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
{ config, pkgs, ... }:

{
  networking = {
    hostName = "router";
    domain = "internal";
    useDHCP = false;
    nftables.enable = true;
    firewall.enable = false;
    extraHosts = ''
      10.0.0.2 server.internal server
      10.0.0.3 host.internal host
    '';
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
    "10-lan" = {
      linkConfig.RequiredForOnline = "yes";
      matchConfig.Name = "lan";
      address = [ "10.0.0.1/24" ];
      dns = [ "127.0.0.1" "1.1.1.1" ];
      domains = [ "internal" ];
    };
    "20-wan" = {
      matchConfig.Name = "wan";
      linkConfig.Unmanaged = "yes";
      linkConfig.RequiredForOnline = "no";
    };
  };
}
```

# PPPoE

```nix
{ config, pkgs, ... }:

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
        usepeerdns
        ifname pppoe0
      '';
    };
  };
}
```

# dnsmasq

```nix
{ config, pkgs, ... }:

{
  service.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      interface = lan
      bind-interfaces = true
      domain = internal

      dhcp-range=10.0.0.127,10.0.0.254,24h
      dhcp-option=3,10.0.0.1
      dhcp-option=6,10.0.0.1
  
      listen-address=127.0.0.1,10.0.0.1
      cache-size=10000
  
      no-resolv
      dhcp-authoritative
    };
  };
}
```

# Firewall

```nix
{ config, pkgs, ... }:

{
  networking.nftables.ruleset = ''
    flush ruleset  # Clear existing rules

    define LAN = "lan"
    define WAN = "wan"

    ##########################
    # Filter table
    ##########################
    table inet filter {

      # INPUT chain - handle incoming traffic
      chain input {
        type filter hook input priority 0;
        policy drop;                       # Default drop

        iif lo accept;                     # Allow loopback
        ct state established,related accept; # Allow established connections

        iif $LAN accept;                   # Allow all traffic from LAN
        iif $WAN tcp dport 22 accept;      # Allow SSH from WAN if needed
      }

      # FORWARD chain - handle routed traffic
      chain forward {
        type filter hook forward priority 0;
        policy drop;                       # Default drop

        iif $LAN oif $WAN accept;          # Allow LAN -> WAN
        iif $WAN oif $LAN ct state established,related accept; # Allow WAN -> LAN responses
        iif $LAN oif $LAN accept;          # Allow LAN internal traffic
      }
    }

    ##########################
    # NAT table
    ##########################
    table ip nat {

      # PREROUTING - port forwarding from WAN
      chain prerouting {
        type nat hook prerouting priority 0;
        tcp dport 2222 iif $WAN dnat to 10.0.0.100:22  # WAN port 2222 -> LAN host 22
      }

      # POSTROUTING - masquerade LAN -> WAN
      chain postrouting {
        type nat hook postrouting priority 100;
        oifname $WAN masquerade;  # Masquerade outgoing WAN traffic
      }
    }
  '';
}
```

# WireGuard

```nix
{ config, pkgs, ... }:

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
    usev4 = "if", "if=wan";
    protocol = "cloudflare";
    zone = "example.com";
    passwordFile = "/run/secrets/ddclient-password";
    domains = [ "example.com" ];
  };
}
```
