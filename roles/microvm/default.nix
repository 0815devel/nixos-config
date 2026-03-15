{ config, pkgs, inputs, ... }:

{
  users.users.root.hashedPassword = "!";
}
