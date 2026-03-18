{ microvm, ... }:

{
  microvm = {
    hypervisor = "qemu";
    mem = 3072;
    vcpu = 1;

    shares = [{
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }];

    interfaces = [{
      type = "tap";
      id = "vm-lan-immich";
      mac = "02:00:00:00:00:09";
    }
    {
      type = "tap";
      id = "vm-nfs-immich";
      mac = "02:00:00:00:00:10";
    }];
  };
  imports = [
    ./config.nix
    ../../roles/base
    ../../roles/headless
    ../../roles/microvm
  ];
}
