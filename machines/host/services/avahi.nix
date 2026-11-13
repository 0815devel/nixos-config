{ config, ... }:

{
  services.avahi = {
    enable = true;
    settings = {
      reflector.enable-reflector = true;
      
      server.use-ipv4 = true;
      server.use-ipv6 = false;

      server.allowInterfaces = [
        "br-lan"
        "br-iot"
      ];
    };
  };
}
