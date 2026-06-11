{ ... }:

{
  networking.nftables.ruleset = ''
    flush ruleset  # Clear existing rules

    define LAN = "lan"
    define WAN = "pppoe0"
    define MODEM = "modem"
    define WIREGUARD = "wg0"

    ##########################
    # Filter table
    ##########################
    table inet filter {

      # OUTPUT chain - handle outcoming traffic
      chain output {
        type filter hook output priority 0;
        # Default accept
        policy accept;
      }

      # INPUT chain - handle incoming traffic
      chain input {
        type filter hook input priority 0;

        # Default drop
        policy drop;

        # Allow loopback
        iifname lo accept;

        # Allow established connections
        ct state established,related accept;

        # Allow Ping
        icmp type echo-request accept;

        # MSS Clamping
        icmp type { destination-unreachable, time-exceeded, parameter-problem } accept;

        # Allow all traffic from LAN
        iifname $LAN accept;

        # Allow Wireguard from WAN
        iifname $WAN udp dport 51820 accept;
      }

      # FORWARD chain - handle routed traffic
      chain forward {
        type filter hook forward priority 0;

        # Default drop
        policy drop;

        # MSS Clamping
        tcp flags syn tcp option maxseg size set rt mtu

        # Allow LAN -> WAN
        iifname $LAN oifname $WAN accept;

        # Allow WAN -> LAN responses
        iifname $WAN oifname $LAN ct state established,related accept;

        # Allow LAN internal traffic
        iifname $LAN oifname $LAN accept;

        # Allow DNAT
        iifname $WAN ip daddr 10.0.0.2 tcp dport { 80, 443 } accept;
      }
    }

    ##########################
    # NAT table
    ##########################
    table ip nat {

      # PREROUTING - port forwarding from WAN
      chain prerouting {
        type nat hook prerouting priority 0;

        # WAN port 80 -> LAN host 80
        iifname $WAN tcp dport 80 dnat to 10.0.0.2:80;

        # WAN port 443 -> LAN host 443
        iifname $WAN tcp dport 443 dnat to 10.0.0.2:443;

        # Force DNS
        iifname $LAN udp dport 53 ip daddr != 10.0.0.1 dnat to 10.0.0.1
      }

      # POSTROUTING
      chain postrouting {
        type nat hook postrouting priority 100;

        # Masquerade ingoing LAN outgoing WAN traffic
        iifname $LAN oifname $WAN masquerade;

        # Masquerade ingoing LAN outgoing MODEM traffic
        iifname $LAN oifname $MODEM masquerade;

        # Masquerade ingoing WIREGUARD outgoing WAN trafic
        iifname $WIREGUARD oifname $WAN masquerade;
      }
    }
  '';
}
