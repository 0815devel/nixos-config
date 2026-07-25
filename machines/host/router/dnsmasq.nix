{ ... }:

{
  service.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      interface = [
        "lo"
        "br-lan"
      ];
      bind-interfaces = true;

      server = [ "1.1.1.1" ];
      no-resolv = true;
      cache-size = 10000;

      dhcp-range = [ "10.0.0.127,10.0.0.254,255.255.255.0,24h" ];
      dhcp-authoritative = true;

      dhcp-option = [
        "option:router,10.0.0.1"
        "option:dns-server,10.0.0.1"
      ];

      domain = "internal";
      expand-hosts = true;
      local = "/internal/";
      domain-needed = true;

      bogus-priv = true;
      stop-dns-rebind = true;
      rebind-localhost-ok = true;

      dhcp-host = [
        "9a:8f:be:c4:e6:92,10.0.0.127,laptop"
        "44:5c:e9:5e:7c:10,10.0.0.131,samsung"
      ];

      address = [ "/lboos.xyz/10.0.0.2" ];

    };
  };
}
