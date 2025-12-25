{ config, pkgs, ... }:

{
  ########################################
  # System Packages
  ########################################
  nixpkgs.config.allowUnfree = true;
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
