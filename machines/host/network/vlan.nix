{ ... }:

{
  systemd.network.netdevs = {

    "vlan-edge" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan-edge";
      };
      vlanConfig.Id = 7;
    };


    "vlan-guest" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan-guest";
      };
      vlanConfig.Id = 20;
    };


    "vlan-iot" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan-iot";
      };
      vlanConfig.Id = 30;
    };

  };

  systemd.network.networks = {

    "vlan-edge" = {
      matchConfig.Name = "vlan-edge";
      networkConfig.Bridge = "br-edge";
      linkConfig.RequiredForOnline = "enslaved";
    };


    "vlan-guest" = {
      matchConfig.Name = "vlan-guest";
      networkConfig.Bridge = "br-guest";
      linkConfig.RequiredForOnline = "enslaved";
    };


    "vlan-iot" = {
      matchConfig.Name = "vlan-iot";
      networkConfig.Bridge = "br-iot";
      linkConfig.RequiredForOnline = "enslaved";
    };

  };
}
