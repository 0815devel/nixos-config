{ ... }:

{
  microvm = {
    hypervisor = "qemu";
    mem = 3072;
    vcpu = 1;
    registerWithMachined = true;

    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
      }
    ];

    interfaces = [
      {
        type = "tap";
        id = "vm-svc-immich";
        mac = "02:00:00:00:00:09";
      }
      {
        type = "tap";
        id = "vm-nfs-immich";
        mac = "02:00:00:00:00:10";
      }
    ];
  };
  imports = [
    ./config.nix
    ../../profiles/base
    ../../profiles/headless
    ../../profiles/microvm
  ];
}
