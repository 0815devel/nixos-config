{ config, pkgs, ... }:

{
  fileSystems."/etc/guacamole" = {
    device = "10.0.1.1:/tank/services/guacamole/data";
    fsType = "nfs";
   };

  networking = {
    hostName = "guacamole";
    useDHCP = false;
    firewall.allowedTCPPorts = [ 22 8080 ];
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

  services = {
    guacamole-server = {
      enable = true;
      host = "127.0.0.1";
      port = 4822;
      userMappingXml = "/etc/guacamole/user-mapping.xml";
    };
    guacamole-client = {
      enable = true;
      enableWebserver = true;
      settings = {
        guacd-port = 4822;
        guacd-hostname = "127.0.0.1";
      };
    };
  };

  system.stateVersion = "25.05";
}
