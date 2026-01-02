{ config, pkgs, inputs, ... }:

{
  ########################################
  # System Packages
  ########################################
  environment.systemPackages = with pkgs; [
    vim
    htop
    zfs
    git
    pciutils
    lshw
    ethtool
  ];
}
