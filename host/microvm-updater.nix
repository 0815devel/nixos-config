{ config, pkgs, microvm, ... }:

let
  vms = [ "foo" "bar" ];
in
{
  ########################################
  # Updater
  ########################################
  systemd.services.microvm-updater = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${microvm.packages.${pkgs.stdenv.hostPlatform.system}.microvm}/bin/microvm -R -u ${builtins.concatStringsSep " " vms}";
    };
  };
  systemd.services.nixos-upgrade.onSuccess = [ "microvm-updater.service" ];
}
