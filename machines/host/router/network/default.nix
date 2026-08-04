{ ... }:

{
  imports = [
    ./netdevs.nix
    ./interfaces.nix
    ./networks.nix
  ];

  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };
}
