{ microvm, ... }:

{
  imports = [
    microvm.nixosModules.host
    ./network.nix
  ];

  microvm.vms = {
    jellyfin.config.imports = [ ./jellyfin ];
    minio.config.imports = [ ./minio ];
    navidrome.config.imports = [ ./navidrome ];
    guacamole.config.imports = [ ./guacamole ];
    immich.config.imports = [ ./immich ];
  };

}
