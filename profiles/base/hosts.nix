{ ... }:

{
  networking.extraHosts = ''

    # LAN
    10.10.10.1 host.home.lboos.xyz host
    10.10.10.10 switch.home.lboos.xyz switch
    10.10.10.11 ap1.home.lboos.xyz ap1
    10.10.10.12 ap2.home.lboos.xyz ap2

    # DMZ
    10.10.50.2 reverse_proxy.home.lboos.xyz reverse_proxy

    # Services
    10.10.60.10 reverse_proxy.home.lboos.xyz reverse_proxy
    10.10.60.11 navidrome.home.lboos.xyz navidrome
    10.10.60.12 immich.home.lboos.xyz immich
    10.10.60.13 jellyfin.home.lboos.xyz jellyfin
  '';
}
