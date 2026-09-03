{ ... }:

{
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;

    settings = {

      interface = [
        "lo"
        "br-lan"
        "br-guest"
        "br-iot"
        "wg-home"
      ];

      bind-interfaces = true;

      server = [
        "1.1.1.1"
      ];

      no-resolv = true;
      cache-size = 10000;

      dhcp-range = [
        "br-lan,10.10.10.100,10.10.10.200,255.255.255.0,24h"

        "br-guest,10.10.20.100,10.10.20.200,255.255.255.0,24h"

        "br-iot,10.10.30.100,10.10.30.200,255.255.255.0,24h"
      ];

      dhcp-authoritative = true;


      dhcp-option = [
        "tag:br-lan,option:router,10.10.10.1"
        "tag:br-lan,option:dns-server,10.10.10.1"

        "tag:br-guest,option:router,10.10.20.1"
        "tag:br-guest,option:dns-server,10.10.20.1"

        "tag:br-iot,option:router,10.10.30.1"
        "tag:br-iot,option:dns-server,10.10.30.1"
      ];


      domain = "home.lboos.xyz";

      expand-hosts = true;

      local = [
        "/home.lboos.xyz/"
      ];

      address = [
        "/lboos.xyz/10.10.50.1"
        "/home.lboos.xyz/"
      ];

      domain-needed = true;
      bogus-priv = true;

      stop-dns-rebind = true;
      rebind-localhost-ok = true;
    };
  };
}
