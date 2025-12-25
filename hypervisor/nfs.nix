{ config, pkgs, ... }:

{
  ########################################
  # NFS Server
  ########################################
  services.nfs.server = {
    enable = true;
    exports = ''
      /tank 10.0.0.127(rw,sync,no_subtree_check)
      /tank/podman 10.0.1.2(rw,sync,no_subtree_check,no_root_squash)
      /tank/media 10.0.1.2(ro,sync,no_subtree_check,no_root_squash)
    '';
  };
}
