{ config, pkgs, ... }:

{
  networking = {
    hostName = "reverse_proxy";
    useDHCP = false;
    firewall.allowedTCPPorts = [
      22
      80
      443
    ];
  };

  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks."lan" = {
      matchConfig.MACAddress = "02:00:00:00:00:07";
      networkConfig = {
        Address = [ "10.0.0.2/24" ];
        Gateway = "10.0.0.1";
        DNS = [ "10.0.0.1" ];
        DHCP = "no";
      };
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts = {

      "nextcloud.lboos.xyz".extraConfig = ''
        reverse_proxy http://10.0.0.23:88 {
            header_up X-Real-IP {remote_host}
            header_up X-Forwarded-For {remote_host}
            header_up X-Forwarded-Proto {scheme}
        }
      '';

      "navidrome.lboos.xyz".extraConfig = ''
        reverse_proxy http://10.0.0.22:4533 {
            header_up X-Real-IP {remote_host}
            header_up X-Forwarded-For {remote_host}
            header_up X-Forwarded-Proto {scheme}
        }
      '';
    };
  };

  system.stateVersion = "25.05";
}
