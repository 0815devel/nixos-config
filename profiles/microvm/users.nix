{ ... }:

{
  users.users.root.hashedPassword = "!";

  users.groups."admin" = {
    gid = 1000;
  };

  users.users."admin" = {
    uid = 1000;
    isNormalUser = true;
    group = "admin";
    extraGroups = [ "wheel" ];
  };
}
