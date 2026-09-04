{ ... }:

{
  networking.extraHosts = ''

    # Host
    10.10.10.1 host.home.lboos.xyz host
    10.10.10.1 host-lan.home.lboos.xyz host-lan
    10.10.20.1 host-guest.home.lboos.xyz host-guest
    10.10.30.1 host-iot.home.lboos.xyz host-iot
    10.10.40.1 host-nfs.home.lboos.xyz host-nfs
    10.10.50.1 host-dmz.home.lboos.xyz host-dmz
    10.10.60.1 host-svc.home.lboos.xyz host-svc

    # LAN
    10.10.10.10 switch.home.lboos.xyz switch
    10.10.10.11 ap1.home.lboos.xyz ap1
    10.10.10.12 ap2.home.lboos.xyz ap2

    # DMZ
    10.10.50.2 reverse_proxy.internal reverse_proxy

    # Services
    10.10.60.10 reverse_proxy.internal reverse_proxy
    10.10.60.11 navidrome.home.lboos.xyz navidrome
    10.10.60.12 immich.home.lboos.xyz immich
    10.10.60.13 jellyfin.home.lboos.xyz jellyfin
  '';
}
