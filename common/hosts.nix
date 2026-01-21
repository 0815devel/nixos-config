{ config, pkgs, inputs, ... }:

{
  networking.extraHosts =
    ''
      10.0.0.1 router.internal router
      10.0.0.2 server.internal server
      10.0.0.3 host.internal host

      10.0.0.10 switch.internal switch
      10.0.0.11 ap1.internal ap1
      10.0.0.12 ap2.internal ap2

      10.0.0.20 jellyfin.internal jellyfin
      10.0.0.21 minio.internal minio
      10.0.0.22 navidrome.internal navidrome
      10.0.0.23 guacamole.internal guacamole
    '';
}
