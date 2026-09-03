{ ... }:

{
  imports = [
    ./netdevs.nix
    ./interfaces.nix
    ./vlan.nix
    ./networks.nix
    ./wireguard.nix
  ];

  networking = {
    hostName = "host";
    domain = "home.lboos.xyz";
    useDHCP = false;
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.arp_filter" = 1;
    "net.ipv4.conf.default.arp_filter" = 1;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };
}
