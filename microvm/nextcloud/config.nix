{ config, pkgs, ... }:

{
  networking = {
    hostName = "nextcloud";
    useDHCP = false;
    firewall.allowedTCPPorts = [ 22 80 ];
  };

  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks."lan" = {
      matchConfig.MACAddress = "02:00:00:00:00:07";
      networkConfig = {
        Address = [ "10.0.0.23/24" ];
        Gateway = "10.0.0.1";
        DNS = [ "10.0.0.1" ];
        DHCP = "no";
      };
    };
    networks."nfs" = {
      matchConfig.MACAddress = "02:00:00:00:00:08";
      networkConfig = {
        Address = [ "10.0.1.23/24" ];
        DHCP = "no";
      };
    };
  };

  system.stateVersion = "25.05";
}
