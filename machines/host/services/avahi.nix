{ config, ... }:

{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    settings = {
      reflector.enable-reflector = true;

      server = {      
        use-ipv4 = true;
        use-ipv6 = false;

        allow-interfaces = [
          "br-lan"
          "br-iot"
        ];
      };
    };
  };
}
