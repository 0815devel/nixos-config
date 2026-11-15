{ config, ... }:

{
  services.ddclient = {
    enable = true;
    interval = "300sec";
    ssl = true;

    usev4 = "webv4, web=checkip.amazonaws.com";

    protocol = "cloudflare";
    zone = "lboos.xyz";

    passwordFile = "/tank/configuration/secrets/cloudflare-dyndns";

    domains = [
      "lboos.xyz"
    ];
  };
}
