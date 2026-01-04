{ config, pkgs, sops-nix, ... }:

{
  ########################################
  # Secrets
  ########################################
  imports = [ sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      "minio_root_user" = {};
      "minio_root_password" = {};
    };

    templates."minio/env" = {
      content = ''
        MINIO_ROOT_USER=${config.sops.placeholder.minio_root_user}
        MINIO_ROOT_PASSWORD=${config.sops.placeholder.minio_root_password}
      '';
      owner = "microvm";
    };
  };
}
