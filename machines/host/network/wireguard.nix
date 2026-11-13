{ config, ... }:

{
  systemd.network.netdevs = {

    "wg-home" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-home";
      };

      wireguardConfig = {
        PrivateKeyFile = "/tank/configuration/secrets/wg-home-interface";

        ListenPort = 51820;
      };

      wireguardPeers = [
        {
          PublicKey =
            "bAE6GcTNdino1PHClucHOA4j4sD2SwD6ihSSmqRt2DE=";

          PresharedKeyFile = "/tank/configuration/secrets/wg-home-peerA";

          AllowedIPs = [
            "10.10.70.2/32"
          ];
        }

        {
          PublicKey =
            "cwZAgoL+h/oZs9h6M+5nFuTS8kw0av0/E5lVF76S7ww=";

          PresharedKeyFile = "/tank/configuration/secrets/wg-home-peerB";

          AllowedIPs = [
            "10.10.70.3/32"
          ];
        }
      ];
    };


    "wg-nld" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-nld";
      };

      wireguardConfig = {
        PrivateKeyFile = "/tank/configuration/secrets/wg-netherlands";

        RouteTable = 51820;
      };

      wireguardPeers = [
        {
          PublicKey =
            "hf+klJbIyUoGUaFHgac9W+yriwb9uvSnafDfnmEW9Hc=";

          AllowedIPs = [
            "0.0.0.0/0"
          ];

          Endpoint =
            "193.32.249.73:51820";

          PersistentKeepalive = 25;
        }
      ];
    };
  };


  systemd.network.networks = {

    "wg-home" = {
      matchConfig.Name = "wg-home";

      address = [
        "10.10.70.1/24"
      ];

      networkConfig = {
        ConfigureWithoutCarrier = true;
      };
    };


    "wg-nld" = {
      matchConfig.Name = "wg-nld";

      address = [
        "10.72.190.93/32"
      ];

      networkConfig = {
        ConfigureWithoutCarrier = true;
      };
    };
  };
}
