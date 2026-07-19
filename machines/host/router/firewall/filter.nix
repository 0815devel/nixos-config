{ ... }:

{
  networking.nftables.tables."filter" = {
    family = "ip";
    content = ''
      define LAN = "lan"
      define WAN = "pppoe0"
      define MODEM = "modem"
      define HOME = "wg0"
      define NETHERLANDS = "wg1"
      define JELLYFIN = "vm-nfs-jellyfin"
      define NAVIDROME = "vm-nfs-music"
      define IMMICH = "vm-nfs-immich"

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

        ct state established,related accept;

        iifname $JELLYFIN ip saddr != 10.0.1.20 drop;
        iifname $NAVIDROME ip saddr != 10.0.1.22 drop;
        iifname $IMMICH ip saddr != 10.0.1.24 drop;

        tcp flags syn tcp option maxseg size set rt mtu

        iifname $LAN oifname $WAN accept;
        iifname $WAN oifname $LAN ct state established,related accept;
        iifname $LAN oifname $LAN accept;

        iifname $WAN ip daddr 10.0.0.2 tcp dport { 80, 443 } accept;

        iifname $HOME oifname $WAN accept;
        iifname $NETHERLANDS oifname $WAN accept;

        iifname $JELLYFIN ip saddr 10.0.1.20 ip daddr 10.0.1.2 tcp dport 2049 accept;
        iifname $NAVIDROME ip saddr 10.0.1.22 ip daddr 10.0.1.2 tcp dport 2049 accept;
        iifname $IMMICH ip saddr 10.0.1.24 ip daddr 10.0.1.2 tcp dport 2049 accept;

    }
    '';
  };
}
