{ config, pkgs, inputs, ... }:

{
  ########################################
  # SSH Server
  ########################################
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
