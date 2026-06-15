{ sops-nix, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops.secrets."wireguard/if" = { };
  sops.secrets."wireguard/a" = { };
  sops.secrets."wireguard/b" = { };
  sops.secrets."wireguard/netherlands" = { };
  sops.secrets."dyndns/cloudflare" = { };
  sops.secrets."pppoe/chap" = { };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/tank/configuration/sops/age/keys.txt";
  };
}
