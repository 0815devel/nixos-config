{ config, pkgs, inputs, ... }:

{
  ########################################
  # Users and Groups
  ########################################
  users.groups."admin" = {
    gid = 1000;
  };

  users.users."admin" = {
    uid = 1000;
    isNormalUser = true;
    group = "admin";
    extraGroups = [ "wheel" "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJOwmCsYLHN1/3eG9Qs1Fo9EkCLt7ir/v7AIpL0nvLZ"
    ];
  };
}
