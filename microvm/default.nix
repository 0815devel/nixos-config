{ microvm, ... }:

{
  imports = [
    microvm.nixosModules.host
    ./network.nix
  ];

  microvm.vms = {
    immich.config.imports = [ ./immich ];
    jellyfin.config.imports = [ ./jellyfin ];
    minio.config.imports = [ ./minio ];
    navidrome.config.imports = [ ./navidrome ];
    reverse_proxy.config.imports = [ ./reverse_proxy ];
  };

}
