{ ... }:

{
  networking = {
    hostName = "router";
    domain = "internal";
    useDHCP = false;
    nftables.enable = true;
    firewall.enable = false;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    netdevs = {
      "br-lan" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-lan";
        };
      };
      "vlan7" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan7";
        };
        vlanConfig.Id = 7;
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
      "lan" = {
        matchConfig.Name = "br-lan";
        linkConfig.RequiredForOnline = "yes";
        address = [ "10.0.0.1/24" ];
        dns = [
          "127.0.0.1"
          "1.1.1.1"
        ];
        domains = [ "internal" ];
        routingPolicyRules = [
          {
            From = "10.0.0.131/32";
            Table = 51820;
            Priority = 100;
          }
        ];
      };
      "modem" = {
        matchConfig.Name = "br-lan";
        vlan = [ "vlan7" ];
        address = [ "10.10.0.1/24" ];
      };
    };
  };
}
