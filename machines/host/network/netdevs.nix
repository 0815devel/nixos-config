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

  };
}
