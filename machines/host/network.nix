{ config, pkgs, ... }:

{
  networking = {
    hostName = "host";
    domain = "internal";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "br-lan" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-lan";
         };
       };
      "br-nfs" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-nfs";
         };
       };
    };
    networks = {
      "lan-onboard" = {
        matchConfig.MACAddress = "9c:6b:00:39:c9:ce";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "lan-nic0" = {
        matchConfig.MACAddress = "a0:36:9f:83:e8:10";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "lan-nic1" = {
        matchConfig.MACAddress = "a0:36:9f:83:e8:11";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "lan-nic2" = {
        matchConfig.MACAddress = "a0:36:9f:83:e8:12";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "lan-nic3" = {
        matchConfig.MACAddress = "a0:36:9f:83:e8:13";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "br-lan" = {
        matchConfig.Name = "br-lan";
        address = [ "10.0.0.3/24" ];
        dns = [ "10.0.0.1" "1.1.1.1" ];
        domains = [ "internal" ];
        gateway = [ "10.0.0.1" ];
      };
      "br-nfs" = {
        matchConfig.Name = "br-nfs";
        address = [ "10.0.1.1/24" ];
        linkConfig.ActivationPolicy = "up";
        networkConfig = {
          ConfigureWithoutCarrier = true;
        };
      };
    };
  };
}
