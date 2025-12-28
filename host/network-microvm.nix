{ config, pkgs, inputs, ... }:

{
  ########################################
  # Network for MicroVM
  ########################################
  systemd.network.networks."vm-lan" = {
    matchConfig.Name = [ "vm-*" ];
    networkConfig.Bridge = "br-lan";
  };
}
