{ config, pkgs, microvm, ... }:

{
########################################
# Updater
########################################
  systemd.services.microvm-updater = {
    script = ''
      for vm in /var/lib/microvms/*; do
        [ -d "$vm" ] || continue
        name="$(basename "$vm")"
        echo "Updating microvm: $name"
        ${microvm.packages.${pkgs.stdenv.hostPlatform.system}.microvm}/bin/microvm -Ru "$name"
      done
    '';

    serviceConfig = {
      Type = "oneshot";
    };
  };

  systemd.services.nixos-upgrade.onSuccess = [ "microvm-updater.service" ];
}
