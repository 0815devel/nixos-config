{ ... }:

{
  systemd.network.netdevs = {

    "br-edge" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-edge";
      };
    };

    "br-guest" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-guest";
      };
    };

    "br-iot" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-iot";
      };
    };

    "br-nfs" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-nfs";
      };
    };

    "br-dmz" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-dmz";
      };
    };

    "br-services" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-services";
      };
    };

    "br-backup" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "br-backup";
      };
    };

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
}
