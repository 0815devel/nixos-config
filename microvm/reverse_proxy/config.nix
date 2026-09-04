{ ... }:

{
  networking = {
    hostName = "reverse_proxy";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = true;
    networks."dmz" = {
      matchConfig.MACAddress = "02:00:00:00:00:07";
      networkConfig = {
        Address = [ "10.10.50.2/24" ];
        DHCP = "no";
      };
    };
    networks."svc" = {
      matchConfig.MACAddress = "02:00:00:00:00:08";
      networkConfig = {
        Address = [ "10.10.60.10/24" ];
        Gateway = "10.10.60.1";
        DNS = [ "10.10.60.1" ];
        DHCP = "no";
      };
    };
  };

  services.caddy = {
    enable = true;
    openFirewall = true;
    httpPort = 80;
    httpsPort = 443;
    virtualHosts = {

      "navidrome.lboos.xyz".extraConfig = ''
        reverse_proxy http://10.10.60.11:4533 {
            header_up X-Real-IP {remote_host}
            header_up X-Forwarded-For {remote_host}
            header_up X-Forwarded-Proto {scheme}
        }
      '';

      "immich.lboos.xyz".extraConfig = ''
        reverse_proxy http://10.10.60.12:2283 {
            header_up X-Real-IP {remote_host}
            header_up X-Forwarded-For {remote_host}
            header_up X-Forwarded-Proto {scheme}

        }
      '';
    };
  };

  system.stateVersion = "25.05";
}
