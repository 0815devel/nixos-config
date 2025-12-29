{ config, pkgs, inputs, ... }:

{
  ########################################
  # Network for MicroVM
  ########################################
  systemd.network.networks."vm-lan" = {
    matchConfig.Name = [ "vm-lan-*" ];
    networkConfig.Bridge = "br-lan";
  };
  systemd.network.networks."vm-wan" = {
    matchConfig.Name = [ "vm-wan-*" ];
    networkConfig.Bridge = "br-wan";
  };
  systemd.network.networks."vm-nfs" = {
    matchConfig.Name = [ "vm-nfs-*" ];
    networkConfig.Bridge = "br-nfs";
  };
}
