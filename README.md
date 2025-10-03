# nixos-config
Repo for my personal NixOS config

# PPPoE

## Private/Public Key
```bash
age-keygen -o ~/.config/sops/age/keys.txt
# Private Key lokal
# Public Key encrypted on GitHub
```

## Secrets

```bash
# secrets.yaml
pppoe-user: user
pppoe-password: password
```

```bash
sops --encrypt --age age1...xyz secrets.yaml > secrets.yaml
```

## NixOS Configuration

```bash
{ config, pkgs, ... }:

{
  imports = [ <sops-nix/modules/sops> ];

  sops.privateKeyFile = "/root/.config/sops/age/keys.txt";

  sops.secrets.pppoe-user = { sopsFile = ./secrets.yaml; };
  sops.secrets.pppoe-password = { sopsFile = ./secrets.yaml; };

  networking.pppoe = {
    enable = true;
    interfaces = [ "eth0" ];
    userNameFile = config.sops.secrets.pppoe-user.path;
    passwordFile = config.sops.secrets.pppoe-password.path;
  };
}
```

# dnsmasq

```bash
{ config, pkgs, ... }:

{
  imports = [ ];

  networking.hostName = "lan-server";

  networking.interfaces.eth0.ipAddress = "10.0.0.1";
  networking.interfaces.eth0.prefixLength = 24;
  networking.interfaces.eth0.ipv6 = false;

  networking.dnsmasq.enable = true;

  networking.dnsmasq.extraConfig = ''
    interface=eth0
    bind-interfaces
    dhcp-range=10.0.0.127,10.0.0.254,24h
    dhcp-option=3,10.0.0.1       # Gateway
    dhcp-option=6,1.1.1.1        # DNS
    dhcp-option=15,internal      # Domain Name
    listen-address=10.0.0.1
    no-resolv
    dhcp-authoritative
  '';
}
```

## SSH

```bash
{ config, pkgs, ... }:

{
  services.openssh.enable = true;

  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";
  services.openssh.challengeResponseAuthentication = false;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEXAMPLEKEYHERE benutzer@client"
    ];
  };

  services.openssh.port = 22;
}
```

## Firewall

```bash
{ config, pkgs, ... }:

{
  networking.firewall.enable = false;

  networking.nftables.enable = true;

  networking.firewall.ipv4Forward = true;

  networking.nftables.extraRules = ''
    flush ruleset

    table inet filter {

      chain input {
        type filter hook input priority 0;
        policy drop;                      
        iif lo accept;                    
        ct state established,related accept;
        iif eth0 accept;
        tcp dport 22 accept;
      }

      chain forward {
        type filter hook forward priority 0;
        policy drop;
        iif eth0 oif eth1 accept;
        iif eth1 oif eth0 ct state established,related accept;
        iif eth0 oif eth0 accept;
      }
    }

    table ip nat {

      chain prerouting {
        type nat hook prerouting priority 0;
        tcp dport 2222 iif "eth1" dnat to 10.0.0.100:22
      }

      chain postrouting {
        type nat hook postrouting priority 100;
        oifname "eth1" masquerade;
      }
    }
  '';
}
```
