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

  sops.secrets."wireguard/interface/privat" = {
    mode = "0640";
    owner = "systemd-network";
    group = "systemd-network";
  };
  sops.secrets."wireguard/peerA/psk" = {
    mode = "0640";
    owner = "systemd-network";
    group = "systemd-network";
  };
  sops.secrets."wireguard/peerB/psk" = {
    mode = "0640";
    owner = "systemd-network";
    group = "systemd-network";
  };
  sops.secrets."wireguard/netherlands/privat" = {
    mode = "0640";
    owner = "systemd-network";
    group = "systemd-network";
  };
  sops.secrets."dyndns/cloudflare" = { };
}
