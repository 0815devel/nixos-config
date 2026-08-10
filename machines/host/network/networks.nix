{ ... }:

{
  systemd.network.networks = {

    "lan" = {
      matchConfig.Name = "br-lan";
      address = [
        "10.10.10.1/24"
      ];

      networkConfig.VLAN = [
        "vlan-edge"
        "vlan-guest"
        "vlan-iot"
      ];
    };


    "edge" = {
      matchConfig.Name = "br-edge";
      address = [
        "172.16.255.1/30"
      ];
      gateway = [
        "172.16.255.2"
      ];
    };


    "guest" = {
      matchConfig.Name = "br-guest";
      address = [
        "10.10.20.1/24"
      ];
    };


    "iot" = {
      matchConfig.Name = "br-iot";
      address = [
        "10.10.30.1/24"
      ];

      routingPolicyRules = [
        {
          From = "10.10.30.0/24";
          Table = 51820;
          Priority = 100;
        }
      ];
    };


    "storage" = {
      matchConfig.Name = "br-nfs";
      address = [
        "10.10.40.1/24"
      ];
      networkConfig.ConfigureWithoutCarrier = true;
    };


    "dmz" = {
      matchConfig.Name = "br-dmz";
      address = [
        "10.10.50.1/24"
      ];
      networkConfig.ConfigureWithoutCarrier = true;
    };


    "services" = {
      matchConfig.Name = "br-services";
      address = [
        "10.10.60.1/24"
      ];
      networkConfig.ConfigureWithoutCarrier = true;
    };


    "backup" = {
      matchConfig.Name = "br-backup";
      address = [
        "10.10.70.1/24"
      ];
      networkConfig.ConfigureWithoutCarrier = true;
    };
  };
}
