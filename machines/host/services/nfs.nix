{ ... }:

{
  services.nfs.server = {
    enable = true;
    exports = ''
      # Transfer
      /tank/transfer *(rw,sync,no_subtree_check,all_squash)

      # Navidrome
      /tank/services/navidrome 10.10.40.11(rw,sync,no_subtree_check,no_root_squash)
      /tank/media/Musik 10.10.40.11(ro,sync,no_subtree_check,no_root_squash)

      # Immich
      /tank/services/immich 10.10.40.12(rw,sync,no_subtree_check,no_root_squash)
      /tank/photos 10.10.40.12(ro,sync,no_subtree_check,no_root_squash)

      # Jellyfin
      /tank/services/jellyfin 10.10.40.13(rw,sync,no_subtree_check,no_root_squash)
      /tank/media/Serien 10.10.40.13(ro,sync,no_subtree_check,no_root_squash)
      /tank/media/Filme 10.10.40.13(ro,sync,no_subtree_check,no_root_squash)
    '';
  };
}
