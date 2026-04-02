# Nextcloud

```nix
environment.etc."nextcloud-admin-pass".text = "password";
services.nextcloud = {
  enable = true;
  #package = pkgs.nextcloud32;
  hostName = "nextcloud.test.xyz";
  home = "/var/lib/nextcloud";
  maxUploadSize = "10G";
  config = {
    adminpassFile = "/etc/nextcloud-admin-pass";
    dbtype = "pgsql";
  };
  settings = {
    trustedDomains = [ "nextcloud.test.xyz" ];
  }
};
```

# Caddy - Reverse Proxy
```nix
services.caddy = {
  enable = true;
  virtualHosts = {
    "navidrome.test.xyz".extraConfig = "reverse_proxy 10.0.0.2:4533";
    "s3.test.xyz".extraConfig = "reverse_proxy 10.0.0.2:9000";
    "minio.test.xyz".extraConfig = "reverse_proxy 10.0.0.2:9001";
    "guacamole.test.xyz".extraConfig = "reverse_proxy 10.0.0.2:8080";
    
    "nextcloud.test.xyz".extraConfig = ''
      reverse_proxy 10.0.0.2:88 {
        header_up Host {host}
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-For {remote_host}
      }
    '';
  };
  extraConfig = ''
    log {
      output file /var/log/caddy/access.log {
        roll_size 10mb
        roll_keep 5
        roll_keep_for 720h
      }
    format json
    }
  '';
};
```
