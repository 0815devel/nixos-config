{ config, pkgs, microvm, ... }:

{
  ########################################
  # Updater
  ########################################
  systemd.timers."update-microvm" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  systemd.services."update-microvm" = {
    script = ''
      ${microvm.packages.${pkgs.stdenv.hostPlatform.system}.microvm}/bin/microvm -R -u test foo
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
