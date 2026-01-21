{ microvm, ... }:

{
  microvm = {
    hypervisor = "qemu";
    mem = 512;
    vcpu = 1;

    shares = [{
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }];

    interfaces = [{
      type = "tap";
      id = "vm-lan-guac";
      mac = "02:00:00:00:00:07";
    }
    {
      type = "tap";
      id = "vm-nfs-guac";
      mac = "02:00:00:00:00:08";
    }];
  };
  imports = [
    ./config.nix
    ../../common/default.nix
  ];
}
