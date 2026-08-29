{ ... }:

{
  fileSystems."/var/lib/navidrome" = {
    device = "10.0.1.1:/tank/services/navidrome/data";
    fsType = "nfs";
  };

  fileSystems."/music" = {
    device = "10.0.1.1:/tank/media/Musik";
    fsType = "nfs";
  };

  networking = {
    hostName = "navidrome";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks."lan" = {
      matchConfig.MACAddress = "02:00:00:00:00:05";
      networkConfig = {
        Address = [ "10.0.0.22/24" ];
        Gateway = "10.0.0.1";
        DNS = [ "10.0.0.1" ];
        DHCP = "no";
      };
    };
    networks."nfs" = {
      matchConfig.MACAddress = "02:00:00:00:00:06";
      networkConfig = {
        Address = [ "10.0.1.22/24" ];
        DHCP = "no";
      };
    };
  };

  services.navidrome = {
    enable = true;
    openFirewall = true;
    user = "admin";
    group = "admin";
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/music";
    };
  };

  system.stateVersion = "25.05";
}
