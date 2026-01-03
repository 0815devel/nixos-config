{ config, pkgs, ... }:

{
  fileSystems."/var/lib/minio/data" = {
      device = "10.0.1.1:/tank/services/minio/data";
      fsType = "nfs";
    };
  fileSystems."/var/lib/minio/config" = {
      device = "10.0.1.1:/tank/services/minio/config";
      fsType = "nfs";
    };

  networking = {
    hostName = "minio";
    useDHCP = false;
    firewall.allowedTCPPorts = [ 22 9000 9001 ];
  };

  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks."lan" = {
      matchConfig.MACAddress = "02:00:00:00:00:03";
      networkConfig = {
        Address = [ "10.0.0.21/24" ];
        Gateway = "10.0.0.1";
        DNS = [ "10.0.0.1" ];
        DHCP = "no";
      };
    };
    networks."nfs" = {
      matchConfig.MACAddress = "02:00:00:00:00:04";
      networkConfig = {
        Address = [ "10.0.1.21/24" ];
        DHCP = "no";
      };
    };
  };

  services.minio = {
    enable = true;
  };

  users.users.root.hashedPassword = "!";
  users.users.admin.password = "password";
  system.stateVersion = "25.05";
}
