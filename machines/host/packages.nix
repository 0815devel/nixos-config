{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    htop
    zfs
    git
    pciutils
    lshw
    ethtool
    nixd
    nil
  ];
}
