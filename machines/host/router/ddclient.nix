{ ... }:

{
  services.ddclient = {
    enable = true;
    interval = 300;
    ssl = true;
    usev4 = "if, if=pppoe0";
    protocol = "cloudflare";
    zone = "lboos.xyz";
    passwordFile = "/run/secrets/ddclient-password";
    domains = [ "lboos.xyz" ];
  };
}
