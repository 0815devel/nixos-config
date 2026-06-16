{ ... }:

{
  services.ddclient = {
    enable = true;
    interval = 300;
    ssl = true;
    usev4 = "if, if=pppoe0";
    protocol = "cloudflare";
    zone = "lboos.xyz";
    passwordFile = config.sops.secrets."dyndns/cloudflare".path;
    domains = [ "lboos.xyz" ];
  };
}
