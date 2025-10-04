# todo

- Policy-Based Routing
- systemd-networkd

# Interfaces

```nix
{ config, pkgs, ... }:

{
networking = {
  hostName = "router.internal";

  # Global DNS
  nameservers = [ "1.1.1.1" ];

  # VLAN 7 on eth1
  vlans.eth1_7 = {
    id = 7;
    interface = "eth1";
  };

  # Interfaces
  interfaces = {
    # LAN
    eth0 = {
      macAddress = "00:11:22:33:44:55";
      ipAddress = "10.0.0.1";
      prefixLength = 24;
      ipv6 = false;
    };

    # WAN physical
    eth1 = {
      macAddress = "66:77:88:99:AA:BB";
      ipv6 = false;
      useDHCP = false;
    };

    # WAN
    eth1_7 = {
      ipv6 = false;
      useDHCP = false; # PPPoE will handle IP
    };
  };
}
```

# PPPoE

## Private/Public Key

```bash
systemd-creds setup --without-tpm2 --secret-key=/root/credential.secret
```

```bash
echo "user" > inexio-user.txt
echo "password" > inexio-password.txt
```

```bash
systemd-creds encrypt --secret-key=/root/credential.secret inexio-user.txt /etc/nixos/secrets/inexio-user.cred
systemd-creds encrypt --secret-key=/root/credential.secret inexio-password.txt /etc/nixos/secrets/inexio-password.cred
```

```bash
rm inexio-user.txt
rm inexio-password.txt
```

## NixOS Configuration

```nix
{ config, pkgs, ... }:

{
    ppp = {
      enable = true;
      peers.inexio = {
        config = ''
          plugin rp-pppoe.so eth1_7
          user "$(cat /run/credentials/pppd@inexio.user)"
          noauth
          defaultroute
          usepeerdns
          persist
          hide-password
          password /run/credentials/pppd@inexio.password
        '';
      };
    };

  systemd.services."pppd@inexio".serviceConfig = {
    LoadCredentialEncrypted = [
      "user:/etc/nixos/secrets/inexio-user.cred"
      "password:/etc/nixos/secrets/inexio-password.cred"
    ];
  };

  environment.systemPackages = with pkgs; [ ppp rp-pppoe ];
}
```

# dnsmasq

```nix
{ config, pkgs, ... }:

{
  networking.dnsmasq.enable = true;

  networking.dnsmasq.extraConfig = ''
    # Bind dnsmasq to LAN interface
    interface=eth0
    bind-interfaces

    # DHCP range
    dhcp-range=10.0.0.127,10.0.0.254,24h

    # DHCP options
    dhcp-option=3,10.0.0.1       # Default gateway for clients
    dhcp-option=6,1.1.1.1        # DNS server for clients
    dhcp-option=15,internal      # Domain name

    # Listen only on LAN IP
    listen-address=10.0.0.1

    no-resolv
    dhcp-authoritative
  '';
}
```

# SSH

```nix
{ config, pkgs, ... }:

{
  services.openssh.enable = true;

  # Allow password login for convenience
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";
  services.openssh.challengeResponseAuthentication = false;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      # Public key for root login
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEXAMPLEKEYHERE benutzer@client"
    ];
  };

  services.openssh.port = 22;  # Listen port
}
```

Firewall (nftables)

```nix
{ config, pkgs, ... }:

{
  networking.firewall.enable = false;  # Disable legacy firewall
  networking.nftables.enable = true;   # Enable nftables
  networking.firewall.ipv4Forward = true; # Enable IP forwarding for routing

  networking.nftables.extraRules = ''
    flush ruleset  # Clear existing rules

    define LAN = "eth0"
    define WAN = "eth1_7"

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
  networking.wireguard.enable = true;

  networking.wireguard.interfaces = {
    wg0 = {
      privateKey = "PRIVATE_KEY";        # Server private key
      listenPort = 51820;                # Listening port
      addresses = [ "10.10.0.1/24" ];   # VPN subnet for server

      peers = [
        {
          publicKey = "PUBLIC_KEY";          # Client public key
          allowedIPs = [ "10.10.0.2/32" ];   # Client IP in VPN
          endpoint = "client.example.com:51820"; # Optional
        }
      ];
    };
  };
}
```

# Caddy

```nix
{ config, pkgs, ... }:

{
  services.caddy.enable = true;
  services.caddy.package = pkgs.caddy;  # use default Caddy package

  # Optional: run as root if binding to ports < 1024
  services.caddy.user = "caddy";

  services.caddy.config = ''
    # Example: Reverse proxy from WAN to internal service
    router.internal {
        reverse_proxy 10.0.0.100:8080
    }

    # Optional TLS (automatic)
    # router.internal {
    #     tls your-email@example.com
    #     reverse_proxy 10.0.0.100:8080
    # }
  '';
}
```

# Fail2Ban

```nix
{ config, pkgs, ... }:

{
  services.fail2ban = {
    enable = true;

    bantime = "1h";        # Ban duration
    findtime = "10m";      # Observation window
    maxretry = 5;          # Retries before ban

    ignoreIP = [ "127.0.0.1/8" "10.0.0.0/24" ]; # Trusted IP ranges

    jails = {
      caddy-http = ''
        enabled = true
        port    = http,https
        filter  = caddy-http
        logpath = /var/log/caddy/access.log
        maxretry = 10
        findtime = 10m
        bantime  = 1h
      '';
    };

    # Custom filter for Caddy
    filters = {
      "caddy-http" = ''
        [Definition]
        failregex = <HOST> -.*"(GET|POST).*HTTP.*" (404|401|403)
        ignoreregex =
      '';
    };
  };
}
```