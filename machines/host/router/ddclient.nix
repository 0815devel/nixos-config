{ config, ... }:

{
  services.ddclient = {
    enable = true;
    interval = 300;
    ssl = true;

    usev4 = "web, web=checkip.amazonaws.com";

    protocol = "cloudflare";
    zone = "lboos.xyz";

    passwordFile =
      config.sops.secrets."dyndns/cloudflare".path;

    domains = [
      "lboos.xyz"
    ];
  };
}
