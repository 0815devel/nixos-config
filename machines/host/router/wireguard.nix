{ ... }:

{
  networking.wireguard = {
    enable = true;
    interfaces = {
      "wg0" = {
        privateKeyFile = "/etc/wireguard/private.key";
        listenPort = 51820;
        ips = [ "10.10.0.1/24" ];
        peers = [
          {
            presharedKeyFile = "/etc/wireguard/preshared.key";
            publicKey = "bAE6GcTNdino1PHClucHOA4j4sD2SwD6ihSSmqRt2DE=";
            allowedIPs = [ "10.10.0.2/32" ];
          }
          {
            presharedKeyFile = "/etc/wireguard/preshared.key";
            publicKey = "cwZAgoL+h/oZs9h6M+5nFuTS8kw0av0/E5lVF76S7ww=";
            allowedIPs = [ "10.10.0.3/32" ];
          }
        ];
      };
    };
  };
}
