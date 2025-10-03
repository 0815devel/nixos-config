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
