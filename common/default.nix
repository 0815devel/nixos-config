{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./users.nix
      ./locale.nix
      ./packages.nix
      ./ssh.nix
      ./hosts.nix
    ];
}
