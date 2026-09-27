{ ... }:

{
  imports = [
    ./filter.nix
    ./nat.nix
    ./bridge.nix
  ];

  networking = {
    nftables.enable = true;
    firewall.enable = false;
  };

}
