{ ... }:

{
  networking.nftables.tables."filter" = {
    family = "inet";
    content = ''
      flush ruleset

      define LAN = "lan"
      define WAN = "pppoe0"
      define MODEM = "modem"
      define WIREGUARD = "wg0"

      table inet filter {

        chain output {
          type filter hook output priority 0;
          policy accept;
        }

        chain input {
          type filter hook input priority 0;
          policy drop;

          iifname lo accept;
          ct state established,related accept;

          icmp type echo-request accept;
          icmp type { destination-unreachable, time-exceeded, parameter-problem } accept;

          iifname $LAN accept;

          iifname $WAN udp dport 51820 accept;
        }

        chain forward {
          type filter hook forward priority 0;
          policy drop;

          tcp flags syn tcp option maxseg size set rt mtu

          iifname $LAN oifname $WAN accept;
          iifname $WAN oifname $LAN ct state established,related accept;
          iifname $LAN oifname $LAN accept;

          iifname $WAN ip daddr 10.0.0.2 tcp dport { 80, 443 } accept;
        }
      }
    '';
  };
}
