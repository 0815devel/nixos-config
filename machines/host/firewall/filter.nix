{ ... }:

{
  networking.nftables.tables."filter" = {
    family = "ip";

    content = ''
      define EDGE = "br-edge"

      define LAN = "br-lan"
      define GUEST = "br-guest"
      define IOT = "br-iot"

      define STORAGE = "br-nfs"
      define DMZ = "br-dmz"
      define SERVICES = "br-services"

      define HOME = "wg-home"
      define NETHERLANDS = "wg-nld"

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
        icmp type {
          destination-unreachable,
          time-exceeded,
          parameter-problem
        } accept;

        iifname $LAN \
          ip saddr 10.10.10.0/24 \
          accept;

        iifname $HOME \
          ip saddr 10.10.70.0/24 \
          accept;

        meta mark 0x110 \
          ip saddr 10.10.40.10 \
          ip daddr 10.10.40.1 \
          tcp dport 2049 \
          accept;

        meta mark 0x111 \
          ip saddr 10.10.40.11 \
          ip daddr 10.10.40.1 \
          tcp dport 2049 \
          accept;

        meta mark 0x112 \
          ip saddr 10.10.40.12 \
          ip daddr 10.10.40.1 \
          tcp dport 2049 \
          accept;

        meta mark 0x113 \
          ip saddr 10.10.40.13 \
          ip daddr 10.10.40.1 \
          tcp dport 2049 \
          accept;

        udp dport 51820 accept;

        udp dport 53 accept
        tcp dport 53 accept
        udp dport 67 accept
        udp dport 68 accept

      }

      chain forward {
        type filter hook forward priority 0;
        policy drop;

        ct state established,related accept;

        iifname $LAN \
          ip saddr 10.10.10.0/24 \
          accept;

        iifname $GUEST \
          ip saddr 10.10.20.0/24 \
          oifname { $EDGE, $DMZ } \
          accept;

        iifname $IOT \
          ip saddr 10.10.30.0/24 \
          oifname { $NETHERLANDS, $DMZ, $IOT } \
          accept;

        iifname $HOME \
          ip saddr 10.10.0.0/24 \
          accept;

        iifname $SERVICES \
          ip saddr 10.10.40.0/24 \
          oifname $EDGE \
          accept;

        iifname $EDGE \
          oifname $DMZ \
          ip daddr 10.10.50.10 \
          tcp dport { 80, 443 } \
          accept;

        iifname $DMZ \
          ip saddr 10.10.50.10 \
          oifname $SERVICES \
          ip daddr { 10.10.60.11, 10.10.60.12 } \
          tcp dport { 4533, 2283 } \
          accept;

        iifname $DMZ \
          ip saddr 10.10.50.10 \
          oifname $EDGE \
          accept;
      }
    '';
  };
}
