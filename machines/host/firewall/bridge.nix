{ ... }:

{
  networking.nftables.tables."vm-marks" = {
    family = "bridge";

    content = ''
        define JELLYFIN = "vm-nfs-jellyfin"
        define NAVIDROME = "vm-nfs-music"
        define IMMICH = "vm-nfs-immich"

        chain prerouting {
          type filter hook prerouting priority -300;

          iifname $NAVIDROME meta mark set 0x111;
          iifname $IMMICH    meta mark set 0x112;
          iifname $JELLYFIN  meta mark set 0x113;
        }
    '';
  };
}
