{ config, pkgs, ... }:

{
  microvm = {
    hypervisor = "qemu";
    mem = 512;
    vcpu = 1;

    interfaces = [
      {
        type = "tap";
        id = "vm-lan-test";
        mac = "93:2C:41:6A:4D:CD";
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
      #matchConfig.MACAddress = "93:2C:41:6A:4D:CD";
      matchConfig.type = "ether";
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

  services.httpd.enable = true;
}
