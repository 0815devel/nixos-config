{ microvm, ... }:

{
  imports = [
    microvm.nixosModules.host
    ./network.nix
  ];

  microvm.vms = {
    reverse_proxy.config.imports = [ ./reverse_proxy ];
    immich.config.imports = [ ./immich ];
    jellyfin.config.imports = [ ./jellyfin ];
    navidrome.config.imports = [ ./navidrome ];
  };

}
