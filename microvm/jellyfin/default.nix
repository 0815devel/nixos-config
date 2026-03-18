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
      id = "vm-lan-jellyfin";
      mac = "02:00:00:00:00:01";
    }
    {
      type = "tap";
      id = "vm-nfs-jellyfin";
      mac = "02:00:00:00:00:02";
    }];
  };
  imports = [
    ./config.nix
    ../../roles/base
    ../../roles/headless
    ../../roles/microvm
  ];
}
