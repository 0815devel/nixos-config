{ config, pkgs, ... }:

let
  mac = "02:00:00:00:00:01";
in
{
  microvm = {
    hypervisor = "qemu";
    mem = 512;
    vcpu = 1;

    interfaces = [
      {
        type = "tap";
        id = "vm-lan-bar";
        mac = mac;
      }
    ];

    shares = [{
      proto = "virtiofs";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    }];
  };

  networking = {
    hostName = "bar";
    useDHCP = false;
    firewall.allowedTCPPorts = [ 22 80 443 ];
  };

  systemd.network = {
    enable = true;
    networks."lan" = {
      matchConfig.MACAddress = mac;
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
