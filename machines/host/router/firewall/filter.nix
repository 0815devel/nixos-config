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
      define BACKUP = "br-backup"

      define HOME = "wg-home"
      define NETHERLANDS = "wg-nld"

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
        icmp type {
          destination-unreachable,
          time-exceeded,
          parameter-problem
        } accept;

        iifname $LAN \
          ip saddr 10.10.10.0/24 \
          accept;

        iifname $HOME \
          ip saddr 10.10.0.0/24 \
          accept;

        iifname $EDGE \
          udp dport 51820 \
          accept;
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
          oifname $EDGE \
          accept;

        iifname $IOT \
          ip saddr 10.10.30.0/24 \
          oifname $NETHERLANDS \
          accept;

        iifname $HOME \
          ip saddr 10.10.0.0/24 \
          oifname $EDGE \
          accept;

        iifname $HOME \
          ip saddr 10.10.0.0/24 \
          oifname $LAN \
          accept;

        iifname $EDGE \
          oifname $DMZ \
          ip daddr 10.10.50.0/24 \
          tcp dport { 80, 443 } \
          accept;

        iifname $DMZ \
          ip saddr 10.10.50.0/24 \
          oifname $SERVICES \
          tcp dport { 80, 443 } \
          accept;

        iifname $JELLYFIN \
          ip saddr 10.10.60.20 \
          oifname $STORAGE \
          ip daddr 10.10.40.0/24 \
          tcp dport 2049 \
          accept;

        iifname $NAVIDROME \
          ip saddr 10.10.60.22 \
          oifname $STORAGE \
          ip daddr 10.10.40.0/24 \
          tcp dport 2049 \
          accept;

        iifname $IMMICH \
          ip saddr 10.10.60.24 \
          oifname $STORAGE \
          ip daddr 10.10.40.0/24 \
          tcp dport 2049 \
          accept;

        iifname $BACKUP \
          ip saddr 10.10.70.0/24 \
          oifname $STORAGE \
          ip daddr 10.10.40.0/24 \
          accept;
      }
    '';
  };
}
