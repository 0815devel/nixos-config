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
    }
    {
      source = "/run/secrets/minio";
      mountPoint = "/etc/minio-root-credentials";
      tag = "secret";
      proto = "virtiofs";
      readOnly = true;
    }];

    interfaces = [{
      type = "tap";
      id = "vm-lan-minio";
      mac = "02:00:00:00:00:03";
    }
    {
      type = "tap";
      id = "vm-nfs-minio";
      mac = "02:00:00:00:00:04";
    }];
  };
  imports = [
    ./config.nix
    ../../common/default.nix
  ];
}
