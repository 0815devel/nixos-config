{ ... }:

{
  networking.nftables.tables."nat" = {
    family = "ip";
    content = ''
      define LAN = "br-lan"
      define WAN = "pppoe0"
      define MODEM = "modem"
      define HOME = "wg-home"
      define NETHERLANDS = "wg-ndl"

      chain prerouting {
        type nat hook prerouting priority 0;

        iifname $WAN tcp dport 80 dnat to 10.0.0.2:80;
        iifname $WAN tcp dport 443 dnat to 10.0.0.2:443;

        iifname $LAN udp dport 53 ip daddr != 10.0.0.1 dnat to 10.0.0.1;
      }

      chain postrouting {
        type nat hook postrouting priority 100;

        iifname $LAN oifname $WAN masquerade;
        iifname $LAN oifname $MODEM masquerade;
        iifname $HOME oifname $WAN masquerade;
        iifname $NETHERLANDS oifname $WAN masquerade;
      }
    '';
  };
}
