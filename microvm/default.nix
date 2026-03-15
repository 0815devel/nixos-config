{ microvm, ... }:

{
  imports = [
    microvm.nixosModules.host
    ./network.nix
  ];

  microvm.vms.jellyfin.config.imports = [ ./jellyfin ];
  microvm.vms.minio.config.imports = [ ./minio ];
  microvm.vms.navidrome.config.imports = [ ./navidrome ];
  microvm.vms.guacamole.config.imports = [ ./guacamole ];
  microvm.vms.immich.config.imports = [ ./immich ];
}
