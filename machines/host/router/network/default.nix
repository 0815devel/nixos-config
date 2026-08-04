{ ... }:

{
  imports = [
    ./netdevs.nix
    ./interfaces.nix
    ./networks.nix
    ./wireguard.nix
  ];

  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };
}
