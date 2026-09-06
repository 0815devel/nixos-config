{ ... }:

{
  microvm = {
    hypervisor = "qemu";
    mem = 512;
    vcpu = 1;
    vsock.cid = 10;

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
        id = "vm-dmz-rp";
        mac = "02:00:00:00:00:07";
      }
      {
        type = "tap";
        id = "vm-svc-rp";
        mac = "02:00:00:00:00:08";
      }
    ];
  };
  imports = [
    ./config.nix
    ../../profiles/base
    ../../profiles/microvm
  ];
}
