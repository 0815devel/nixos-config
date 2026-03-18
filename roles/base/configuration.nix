{ config, pkgs, inputs, ... }:

{
  ########################################
  # Nix / nixpkgs
  ########################################
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;
}
