
{ ... }:

{
  services.unbound = {
    enable = true;

    settings = {
      server = {
        interface = [
          "127.0.0.1"
          "10.10.10.1"
          "10.10.20.1"
          "10.10.30.1"
        ];

        port = 53;

        access-control = [
          "127.0.0.0/8 allow"
          "10.10.10.0/24 allow"
          "10.10.20.0/24 allow"
          "10.10.30.0/24 allow"
        ];

        qname-minimisation = true;
        harden-dnssec-stripped = true;
        module-config = "'respip validator iterator'";

        local-zone = [
          "\"home.lboos.xyz.\" static"
          "\"lboos.xyz.\" typetransparent"
        ];

        local-data = [
          "host.home.lboos.xyz. IN A 10.10.10.1"
          "switch.home.lboos.xyz. IN A 10.10.10.10"
          "ap1.home.lboos.xyz. IN A 10.10.10.11"
          "ap2.home.lboos.xyz. IN A 10.10.10.12"

          "wireguard.lboos.xyz. IN A 10.10.50.1"
          "reverse_proxy.home.lboos.xyz. IN A 10.10.50.10"

          "navidrome.home.lboos.xyz. IN A 10.10.60.11"
          "immich.home.lboos.xyz. IN A 10.10.60.12"
          "jellyfin.home.lboos.xyz. IN A 10.10.60.13"
          
        ];
      };

      rpz = [
        {
          name = "hageziPro";
          url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/rpz/pro.txt";
        }
      ];
    };
  };
}
