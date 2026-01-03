# Navidrome

```nix
services.navidrome = {
  enable = true;
  openFirewall = true;
  settings = {
    Address = "127.0.0.1";
    Port = 4533;
  }
};
```

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

# Guacamole

```nix
services = {
  guacamole-server = {
    enable = true;
    host = "127.0.0.1";
    port = 4822;
    userMappingXml = ./guacamole/user-mapping.xml;
  };
  guacamole-client = {
    enable = true;
    enableWebserver = true;
    settings = {
      guacd-port = 4822;
      guacd-hostname = "127.0.0.1";
    };
  };
};
```

# Immich

```nix
services.immich = {
  enable = true;
  openFirewall = true;
  port = 2283;
  host = "127.0.0.1";
  mediaLocation = "/var/lib/immich/media";
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
    "nextcloud.test.xyz".extraConfig = "reverse_proxy 10.0.0.2:88";
    "guacamole.test.xyz".extraConfig = "reverse_proxy 10.0.0.2:8080";
  };
};
```

# Backup Databases

```nix
services.postgresqlBackup = {
  enable = true;
  databases = [ "nextcloud" "immich" ];
  location = "/var/backup/postgresql";
};
```
