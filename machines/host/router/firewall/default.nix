{ ... }:

{
  imports = [
    ./filter.nix
    ./nat.nix
  ];
}

networking = {
  nftables.enable = true;
  firewall.enable = false;
};
