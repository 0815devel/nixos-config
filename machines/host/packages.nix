{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    zfs
    git
    pciutils
    lshw
    ethtool
    wireguard-tools
    tcpdump
    nixd
    nil
  ];
}
