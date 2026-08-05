{ ... }:

{
  systemd.network.networks."vm-lan" = {
    matchConfig.Name = [ "vm-lan-*" ];
    networkConfig.Bridge = "br-lan";
  };
  systemd.network.networks."vm-nfs" = {
    matchConfig.Name = [ "vm-nfs-*" ];
    networkConfig.Bridge = "br-nfs";
  };
    systemd.network.networks."vm-dmz" = {
    matchConfig.Name = [ "vm-dmz-*" ];
    networkConfig.Bridge = "br-dmz";
  };
    systemd.network.networks."vm-services" = {
    matchConfig.Name = [ "vm-services-*" ];
    networkConfig.Bridge = "br-services";
  };
}
