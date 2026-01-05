{ config, pkgs, sops-nix, ... }:

{
  sops.secrets."minio/env" = {
    owner = "microvm";
  };
}
