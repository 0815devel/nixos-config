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
      id = "vm-lan-rp";
      mac = "02:00:00:00:00:07";
    }];
  };
  imports = [
    ./config.nix
    ../../profiles/base
    ../../profiles/headless
    ../../profiles/microvm
  ];
}
