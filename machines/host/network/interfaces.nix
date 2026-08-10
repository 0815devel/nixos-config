{ ... }:

{
  systemd.network.networks = {

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


    "edge-vlan" = {
      matchConfig.Name = "vlan-edge";
      networkConfig.Bridge = "br-edge";
      linkConfig.RequiredForOnline = "enslaved";
    };


    "guest-vlan" = {
      matchConfig.Name = "vlan-guest";
      networkConfig.Bridge = "br-guest";
      linkConfig.RequiredForOnline = "enslaved";
    };


    "iot-vlan" = {
      matchConfig.Name = "vlan-iot";
      networkConfig.Bridge = "br-iot";
      linkConfig.RequiredForOnline = "enslaved";
    };

    "lan-vlans" = {
      matchConfig.Name = "br-lan";
      networkConfig.VLAN = [
        "vlan-edge"
        "vlan-guest"
        "vlan-iot"
      ];
    };

  };
}
