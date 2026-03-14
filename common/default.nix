{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./users.nix
      ./locale.nix
      ./ssh.nix
      ./hosts.nix
    ];
}
