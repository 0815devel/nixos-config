# nixos-config
Repo for my personal NixOS config

# Interfaces

```nix
{ config, pkgs, ... }:

{
  networking.hostName = "router.internal";

  networking.interfaces = {
    # LAN interface
    eth0 = {
      macAddress = "00:11:22:33:44:55";
      ipAddress = "10.0.0.1";   # LAN gateway IP
      prefixLength = 24;
      ipv6 = false;
    };

    # WAN interface
    eth1 = {
      macAddress = "66:77:88:99:AA:BB";
      ipv6 = false;
      useDHCP = false;          # PPPoE will handle IP
    };
  };
}
```

# PPPoE

## Private/Public Key

```bash
age-keygen -o ~/.config/sops/age/keys.txt
# Private Key is kept locally
# Public Key encrypted and stored on GitHub
```

## Secrets

```yaml
# secrets.yaml
pppoe-user: user
pppoe-password: password
```

```bash
sops --encrypt --age age1...xyz secrets.yaml > secrets.yaml
```

## NixOS Configuration

```nix
{ config, pkgs, ... }:

{
  imports = [ <sops-nix/modules/sops> ];

  # Path to private age key
  sops.privateKeyFile = "/root/.config/sops/age/keys.txt";

  # PPPoE secrets
  sops.secrets.pppoe-user = { sopsFile = ./secrets.yaml; };
  sops.secrets.pppoe-password = { sopsFile = ./secrets.yaml; };

  networking.pppoe = {
    enable = true;
    interfaces = [ "eth1" ]; # WAN interface
    userNameFile = config.sops.secrets.pppoe-user.path;
    passwordFile = config.sops.secrets.pppoe-password.path;
  };
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

        iif eth0 accept;                   # Allow all traffic from LAN
        iif eth1 tcp dport 22 accept;      # Allow SSH from WAN if needed
      }

      # FORWARD chain - handle routed traffic
      chain forward {
        type filter hook forward priority 0;
        policy drop;                       # Default drop

        iif eth0 oif eth1 accept;          # Allow LAN -> WAN
        iif eth1 oif eth0 ct state established,related accept; # Allow WAN -> LAN responses
        iif eth0 oif eth0 accept;          # Allow LAN internal traffic
      }
    }

    ##########################
    # NAT table
    ##########################
    table ip nat {

      # PREROUTING - port forwarding from WAN
      chain prerouting {
        type nat hook prerouting priority 0;
        tcp dport 2222 iif "eth1" dnat to 10.0.0.100:22  # WAN port 2222 -> LAN host 22
      }

      # POSTROUTING - masquerade LAN -> WAN
      chain postrouting {
        type nat hook postrouting priority 100;
        oifname "eth1" masquerade;  # Masquerade outgoing WAN traffic
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
  services.caddy.user = "root";

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

# Policy-Based Routing

```nix
{ config, pkgs, ... }:

{
  networking.routing.tables = {
    # Table 100 for PPPoE WAN
    100 = { name = "pppoe"; };
    # Table 200 for WireGuard VPN
    200 = { name = "vpn"; };
  };

  networking.routing.rules = [
    # Route all traffic from LAN host 10.0.0.50 via VPN
    { from = "10.0.0.50"; table = "vpn"; priority = 100; }

    # Default LAN traffic via WAN (PPPoE)
    { from = "10.0.0.0/24"; table = "pppoe"; priority = 200; }
  ];

  # Routes per table
  networking.routes = {
    # PPPoE table: use interface only, dynamic gateway assigned by PPPoE
    "pppoe" = [
      { dev = "eth1"; }  # Default route uses PPPoE interface
    ];

    # VPN table: interface-based routing
    "vpn" = [
      { dev = "wg0"; }
    ];
  };
}
```
