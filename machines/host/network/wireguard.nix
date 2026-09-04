{ config, ... }:

{
  systemd.network.netdevs = {

    "wg-home" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg-home";
      };

      wireguardConfig = {
        PrivateKeyFile =
          config.sops.secrets."wireguard/interface/privat".path;

        ListenPort = 51820;
      };

      wireguardPeers = [
        {
          PublicKey =
            "bAE6GcTNdino1PHClucHOA4j4sD2SwD6ihSSmqRt2DE=";

          PresharedKeyFile =
            config.sops.secrets."wireguard/peerA/psk".path;

          AllowedIPs = [
            "10.10.70.2/32"
          ];
        }

        {
          PublicKey =
            "cwZAgoL+h/oZs9h6M+5nFuTS8kw0av0/E5lVF76S7ww=";

          PresharedKeyFile =
            config.sops.secrets."wireguard/peerB/psk".path;

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
        PrivateKeyFile =
          config.sops.secrets."netherlands/privat".path;

        RouteTable = 51820;
      };

      wireguardPeers = [
        {
          PublicKey =
            "UrQiI9ISdPPzd4ARw1NHOPKKvKvxUhjwRjaI0JpJFgM=";

          AllowedIPs = [
            "0.0.0.0/0"
          ];

          Endpoint =
            "193.32.249.66:51820";

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
