{ sops-nix, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/tank/configuration/sops/age/keys.txt";
  };

  sops.secrets."wireguard/if/privat" = { };
  sops.secrets."wireguard/a/psk" = { };
  sops.secrets."wireguard/b/psk" = { };
  sops.secrets."wireguard/netherlands/privat" = { };
  sops.secrets."dyndns/cloudflare" = { };
  sops.secrets."pppoe/chap" = { };
}
