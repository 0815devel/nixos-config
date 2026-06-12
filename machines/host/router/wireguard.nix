{ ... }:

{
  systemd.network = {
    enable = true;
    netdevs = {
      "wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };
        wireguardConfig = {
          PrivateKeyFile = "/etc/wireguard/private.key";
          ListenPort = 51820;
        };
        wireguardPeers = [
          {
            PublicKey = "bAE6GcTNdino1PHClucHOA4j4sD2SwD6ihSSmqRt2DE=";
            PresharedKeyFile = "/etc/wireguard/preshared.key";
            AllowedIPs = [ "10.10.0.2/32" ];
          }
          {
            PublicKey = "cwZAgoL+h/oZs9h6M+5nFuTS8kw0av0/E5lVF76S7ww=";
            PresharedKeyFile = "/etc/wireguard/preshared.key";
            AllowedIPs = [ "10.10.0.3/32" ];
          }
        ];
      };
    };
    networks = {
      "wg0" = {
        matchConfig.Name = "wg0";
        address = [ "10.10.0.1/24" ];
        networkConfig = {
          ConfigureWithoutCarrier = true;
        };
      };
    };
  };

}
