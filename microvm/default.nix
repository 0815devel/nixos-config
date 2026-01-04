{ microvm, ... }:

{
  imports = [
    microvm.nixosModules.host
    ./network.nix
  ];
  users.users.microvm.extraGroups = [ "keys" ];

  microvm.vms.jellyfin.config.imports = [ ./jellyfin/default.nix ];
  microvm.vms.minio.config.imports = [ ./minio/default.nix ];
}
