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
      id = "vm-lan-music";
      mac = "02:00:00:00:00:05";
    }
    {
      type = "tap";
      id = "vm-nfs-music";
      mac = "02:00:00:00:00:06";
    }];
  };
  imports = [
    ./config.nix
    ../../roles/base
    ../../roles/headless
    ../../roles/microvm
  ];
}
