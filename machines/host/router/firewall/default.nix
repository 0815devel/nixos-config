{ ... }:

{
  imports = [
    ./filter.nix
    ./nat.nix
  ];
  nftables.enable = true;
  firewall.enable = false;
}
