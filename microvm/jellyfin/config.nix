{ pkgs, ... }:

{
  fileSystems."/var/lib/jellyfin" = {
    device = "10.10.40.1:/tank/services/jellyfin/config";
    fsType = "nfs";
  };

  fileSystems."/var/cache/jellyfin" = {
    device = "10.10.40.1:/tank/services/jellyfin/cache";
    fsType = "nfs";
  };

  fileSystems."/media" = {
    device = "10.10.40.1:/tank/media";
    fsType = "nfs";
  };

  networking = {
    hostName = "jellyfin";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks."svc" = {
      matchConfig.MACAddress = "02:00:00:00:00:01";
      networkConfig = {
        Address = [ "10.10.60.13/24" ];
        Gateway = "10.10.60.1";
        DNS = [ "10.10.60.1" ];
        DHCP = "no";
      };
    };
    networks."nfs" = {
      matchConfig.MACAddress = "02:00:00:00:00:02";
      networkConfig = {
        Address = [ "10.10.40.13/24" ];
        DHCP = "no";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "admin";
    group = "admin";
  };

  system.stateVersion = "25.05";
}
