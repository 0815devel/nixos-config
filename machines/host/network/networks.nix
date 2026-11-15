{ ... }:

{
  systemd.network.networks = {

    "lan" = {
      matchConfig.Name = "br-lan";
      address = [
        "10.10.10.1/24"
      ];

      vlan = [
        "vlan-edge"
        "vlan-guest"
        "vlan-iot"
      ];

      #networkConfig = {
      #  DHCPServer = true;
      #};

      #dhcpServerConfig = {
      #  PoolOffset = 100;
      #  PoolSize = 100;
      #  EmitDNS = true;
      #  DNS = "_server_address";
      #  EmitRouter = true;
      #  DefaultLeaseTimeSec = 3600;
      #  MaxLeaseTimeSec = 7200;
      #};
    };
    

    "edge" = {
      matchConfig.Name = "br-edge";
      address = [
        "172.16.255.1/30"
      ];
      gateway = [
        "172.16.255.2"
      ];
      cakeConfig = { 
        Bandwidth = "13.5M"; 
      };
    };


    "guest" = {
      matchConfig.Name = "br-guest";
      address = [
        "10.10.20.1/24"
      ];

      #networkConfig = {
      #  DHCPServer = true;
      #};

      #dhcpServerConfig = {
      #  PoolOffset = 100;
      #  PoolSize = 100;
      #  EmitDNS = true;
      #  DNS = "_server_address";
      #  EmitRouter = true;
      #  DefaultLeaseTimeSec = 3600;
      #  MaxLeaseTimeSec = 7200;
      #};
    };


    "iot" = {
      matchConfig.Name = "br-iot";
      address = [
        "10.10.30.1/24"
      ];

      routes = [
        {
          Destination = "10.10.30.0/24";
          Scope = "link";
          Table = 51820;
        }
      ];

      routingPolicyRules = [
        {
          From = "10.10.30.0/24";
          Table = 51820;
          Priority = 100;
        }
      ];

      #networkConfig = {
      #  DHCPServer = true;
      #};

      #dhcpServerConfig = {
      #  PoolOffset = 100;
      #  PoolSize = 100;
      #  EmitDNS = true;
      #  DNS = "_server_address";
      #  EmitRouter = true;
      #  DefaultLeaseTimeSec = 3600;
      #  MaxLeaseTimeSec = 7200;
      #};
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

  };
}
