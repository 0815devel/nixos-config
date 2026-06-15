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

  sops.secrets."wireguard/interface/privat" = { };
  sops.secrets."wireguard/peerA/psk" = { };
  sops.secrets."wireguard/peerB/psk" = { };
  sops.secrets."wireguard/netherlands/privat" = { };
  sops.secrets."dyndns/cloudflare" = { };
  sops.secrets."pppoe/chap" = { };
}
