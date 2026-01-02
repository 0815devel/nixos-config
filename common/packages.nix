{ config, pkgs, inputs, ... }:

{
  ########################################
  # System Packages
  ########################################
  environment.systemPackages = with pkgs; [
    neovim
    htop
    zfs
    git
    pciutils
    lshw
    ethtool
  ];
}
