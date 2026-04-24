{ config, pkgs, ... }:

{
  services.nfs.server = {
    enable = true;
    exports = ''
      # Laptop
      /tank 10.0.0.127(rw,sync,no_subtree_check)

      # Server
      /tank/podman 10.0.1.2(rw,sync,no_subtree_check,no_root_squash)
      /tank/media 10.0.1.2(ro,sync,no_subtree_check,no_root_squash)

      # Jellyfin
      /tank/services/jellyfin 10.0.1.20(rw,sync,no_subtree_check,no_root_squash)
      /tank/media/Serien 10.0.1.20(ro,sync,no_subtree_check,no_root_squash)
      /tank/media/Filme 10.0.1.20(ro,sync,no_subtree_check,no_root_squash)

      # Minio
      /tank/services/minio 10.0.1.21(rw,sync,no_subtree_check,no_root_squash)

      # Navidrome
      /tank/services/navidrome 10.0.1.22(rw,sync,no_subtree_check,no_root_squash)
      /tank/media/Musik 10.0.1.22(ro,sync,no_subtree_check,no_root_squash)

      # Guacamole
      /tank/services/guacamole 10.0.1.23(rw,sync,no_subtree_check,no_root_squash)

      # Immich
      /tank/services/immich 10.0.1.24(rw,sync,no_subtree_check,no_root_squash)
    '';
  };
}
