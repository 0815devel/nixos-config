{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./users.nix
      ./ssh.nix
    ];
}
