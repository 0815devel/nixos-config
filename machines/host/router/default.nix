{ ... }:

{
  imports = [
    ./pppoe.nix
    ./dnsmasq.nix
    ./ddclient.nix
    ./wireguard.nix
    ./network
    ./firewall
  ];

  networking = {
    hostName = "router";
    domain = "internal";
    useDHCP = false;
  };

  nftables.enable = true;
  firewall.enable = false;

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = "1";
    "net.ipv6.conf.all.forwarding" = "0";
    "net.ipv4.conf.all.arp_filter" = "1";
    "net.ipv4.conf.default.arp_filter" = "1";
  };
}
