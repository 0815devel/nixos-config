{ config, pkgs, inputs, ... }:

{
  ########################################
  # Secrets
  ########################################
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/root/.config/sops/age/keys.txt";

    secrets = {
      "MINIO_ROOT_USER" = {};
      "MINIO_ROOT_PASSWORD" = {};
    };

    templates."minio-env".content = ''
        MINIO_ROOT_USER=${config.sops.placeholder.MINIO_ROOT_USER}
        MINIO_ROOT_PASSWORD=${config.sops.placeholder.MINIO_ROOT_PASSWORD}
    '';
  };
}
