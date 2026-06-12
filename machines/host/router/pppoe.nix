{ ... }:

{

  system.activationScripts.pppoeSecret.text = ''
    install -D -m 600 /tank/secrets/key /etc/ppp/chap-secrets;
  '';

  services.pppd = {
    enable = true;
    peers."inexio" = {
      autostart = true;
      enable = true;
      config = ''
        plugin rp-pppoe.so modem
        name "<USERNAME>"
        noipdefault
        hide-password
        lcp-echo-interval 20
        lcp-echo-failure 3
        noauth
        persist
        maxfail 0
        holdoff 30
        mtu 1492
        mru 1492
        noaccomp
        noproxyarp
        default-asyncmap
        noipv6
        nodefaultroute
        noreplacedefaultroute
        ifname pppoe0
      '';
    };
  };
}
