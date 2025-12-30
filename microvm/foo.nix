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
        mac = "39:03:05:5C:63:1E";
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
      #matchConfig.MACAddress = "39:03:05:5C:63:1E";
      matchConfig.type = "ether";
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

  services.nginx.enable = true;
}
