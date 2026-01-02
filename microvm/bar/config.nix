{ config, pkgs, ... }:

{
  networking = {
    hostName = "bar";
    useDHCP = false;
    firewall.allowedTCPPorts = [ 22 80 443 ];
  };

  systemd.network = {
    enable = true;
    networks."lan" = {
      matchConfig.MACAddress = "02:00:00:00:00:01";
      networkConfig = {
        Address = [ "10.0.0.99/24" ];
        Gateway = "10.0.0.1";
        DNS = [ "10.0.0.1" ];
        DHCP = "no";
      };
    };
  };

  users.users.root.hashedPassword = "!";
  system.stateVersion = "25.05";

  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      locations."/" = {
        return = "200 \"<html><body>It's bar: It works</body></html>\"";
        extraConfig = "default_type text/html;";
      };
    };
  };
}
