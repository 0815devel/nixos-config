# nixos-config
Repo for my personal NixOS config

# Schritt-für-Schritt-Anleitung: PPPoE unter NixOS mit verschlüsseltem Passwort

---

## Private/Public Key erzeugen
```bash
age-keygen -o ~/.config/sops/age/keys.txt
# Private Key bleibt lokal
# Public Key ins Repo zum Verschlüsseln
```


---

## Secrets erstellen und verschlüsseln

### secrets.yaml
```bash
pppoe-user: dein-user
pppoe-password: dein-geheimes-passwort
```

```bash
sops --encrypt --age age1...xyz secrets.yaml > secrets.yaml
```

---

## NixOS-Konfiguration

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
