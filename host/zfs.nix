{ config, pkgs, inputs, ... }:

{
  ########################################
  # ZFS
  ########################################
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "tank" ];

    kernelParams = [
      "zfs.zfs_arc_max=4294967296" # ARC 4GiB max
    ];
  };

  networking.hostId = "4e98920d";

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
    autoSnapshot.enable = true;
  };
}
