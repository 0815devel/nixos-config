{ config, pkgs, ... }:

{
  microvm = {
    hypervisor = "qemu";
    mem = 512;
    vcpu = 1;

    interfaces = [
      {
        type = "tap";
        id = "vm-test";
        mac = "02:00:00:00:00:09";
      }
    ];

    shares = [{
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }];
  };

  networking = {
    hostName = "test";
    firewall.allowedTCPPorts = [ 22 80 443 ];
  };

  systemd.network = {
    enable = true;
    networks."lan" = {
      matchConfig.Type = "ether";
      networkConfig = {
        Address = [ "10.0.0.9/24" ];
        Gateway = "10.0.0.1";
        DNS = [ "10.0.0.1" ];
        DHCP = "no";
      };
    };
  };

  services.httpd.enable = true;

  users.groups."admin" = {
    gid = 1000;
  };

  users.users."admin" = {
    uid = 1000;
    isNormalUser = true;
    group = "admin";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJOwmCsYLHN1/3eG9Qs1Fo9EkCLt7ir/v7AIpL0nvLZ"
    ];
  };

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "25.05";
}
