{ ... }:

{
  networking.nftables.tables."nat" = {
    family = "ip";

    content = ''
      define EDGE = "br-edge"

      define LAN = "br-lan"
      define GUEST = "br-guest"
      define IOT = "br-iot"
      define DMZ = "br-dmz"
      define SERVICE = "br-service"

      define HOME = "wg-home"
      define NETHERLANDS = "wg-nld"


      chain prerouting {
        type nat hook prerouting priority 0;

        iifname $EDGE tcp dport 80  dnat to 10.10.50.2:80;
        iifname $EDGE tcp dport 443 dnat to 10.10.50.2:443;

        iifname $LAN udp dport 53 ip daddr != 10.10.10.1 dnat to 10.10.10.1;
        iifname $LAN tcp dport 53 ip daddr != 10.10.10.1 dnat to 10.10.10.1;

        iifname $GUEST udp dport 53 ip daddr != 10.10.20.1 dnat to 10.10.20.1;
        iifname $GUEST tcp dport 53 ip daddr != 10.10.20.1 dnat to 10.10.20.1;

        iifname $IOT udp dport 53 ip daddr != 10.10.30.1 dnat to 10.10.30.1;
        iifname $IOT tcp dport 53 ip daddr != 10.10.30.1 dnat to 10.10.30.1;
      }


      chain postrouting {
        type nat hook postrouting priority 100;

        iifname $LAN ip saddr 10.10.10.0/24 oifname $EDGE masquerade;
        iifname $GUEST ip saddr 10.10.20.0/24 oifname $EDGE masquerade;
        iifname $IOT ip saddr 10.10.30.0/24 oifname $NETHERLANDS masquerade;
        iifname $DMZ ip saddr 10.10.50.0/24 oifname $EDGE masquerade;
        iifname $SERVICE ip saddr 10.10.60.0/24 oifname $EDGE masquerade;
        iifname $HOME ip saddr 10.10.80.0/24 oifname $EDGE masquerade;
      }
    '';
  };
}
