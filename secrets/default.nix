{ config, pkgs, sops-nix, ... }:

{
  ########################################
  # Secrets
  ########################################
  imports = [
    sops-nix.nixosModules.sops
    ./minio.nix
  ];

  users.users.microvm.extraGroups = [ "keys" ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/tank/configuration/sops/age/keys.txt";
  };
}
