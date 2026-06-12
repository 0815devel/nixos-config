{ config, pkgs, sops-nix, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  users.users.microvm.extraGroups = [ "keys" ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/tank/configuration/sops/age/keys.txt";
  };
}
