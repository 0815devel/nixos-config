{ config, ... }:

{
  services.avahi = {
    enable = true;
    reflector = true;

    ipv4 = true;
    ipv6 = false;

    allowInterfaces = [
      "br-lan"
      "br-iot"
    ];
  };
}
