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

  networking.firewall.enable = true;
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
