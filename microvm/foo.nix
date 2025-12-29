{ config, pkgs, ... }:

{
  microvm = {
    hypervisor = "qemu";
    mem = 512;
    vcpu = 1;

    interfaces = [
      {
        type = "tap";
        id = "vm-lan-foo";
        mac = "02:00:00:00:00:10";
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
    hostName = "foo";
    useDHCP = false;
    firewall.allowedTCPPorts = [ 22 80 443 ];
  };

  systemd.network = {
    enable = true;
    networks."lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [ "10.0.0.98/24" ];
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
