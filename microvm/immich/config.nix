{ ... }:

{
  fileSystems."/var/lib/immich" = {
    device = "10.10.40.1:/tank/services/immich/data";
    fsType = "nfs";
  };
  fileSystems."/var/cache/immich" = {
    device = "10.10.40.1:/tank/services/immich/cache";
    fsType = "nfs";
  };
  fileSystems."/var/lib/postgresql" = {
    device = "10.10.40.1:/tank/services/immich/db";
    fsType = "nfs";
  };
  fileSystems."/media" = {
    device = "10.10.40.1:/tank/photos";
    fsType = "nfs";
  };

  networking = {
    hostName = "immich";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks."svc" = {
      matchConfig.MACAddress = "02:00:00:00:00:09";
      networkConfig = {
        Address = [ "10.10.60.12/24" ];
        Gateway = "10.10.60.1";
        DNS = [ "10.10.60.1" ];
        DHCP = "no";
      };
    };
    networks."nfs" = {
      matchConfig.MACAddress = "02:00:00:00:00:10";
      networkConfig = {
        Address = [ "10.10.40.12/24" ];
        DHCP = "no";
      };
    };
  };

  services.immich = {
    enable = true;
    openFirewall = true;
    port = 2283;
    host = "0.0.0.0";
    mediaLocation = "/var/lib/immich/media";
  };

  system.stateVersion = "25.05";
}
