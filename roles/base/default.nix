{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./locale.nix
      ./hosts.nix
      ./configuration.nix
    ];
}
