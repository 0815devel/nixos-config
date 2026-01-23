{ microvm, ... }:

{
  imports = [
    microvm.nixosModules.host
    ./network.nix
  ];

  microvm.vms.jellyfin.config.imports = [ ./jellyfin/default.nix ];
  microvm.vms.minio.config.imports = [ ./minio/default.nix ];
  microvm.vms.navidrome.config.imports = [ ./navidrome/default.nix ];
  microvm.vms.guacamole.config.imports = [ ./guacamole/default.nix ];
  microvm.vms.immich.config.imports = [ ./immich/default.nix ];
}
