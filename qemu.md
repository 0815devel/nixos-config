```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.vms;

  allBridges = lib.unique (
    lib.concatLists (lib.mapAttrsToList (_: vm: vm.bridgeAllow) cfg)
  );

in
{
  options.virtualisation.vms = mkOption {
    type = types.attrsOf (types.submodule ({ name, ... }: {
      options = {

        enable = mkEnableOption "VM ${name}";

        qemuArgs = mkOption {
          type = types.lines;
          description = "Raw QEMU arguments (after binary)";
        };

        bridgeAllow = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "Bridges allowed for QEMU bridge helper";
        };

        enableQmp = mkOption {
          type = types.bool;
          default = true;
          description = "Enable QMP socket for lifecycle control";
        };

        enableSerial = mkOption {
          type = types.bool;
          default = true;
          description = "Enable serial console socket";
        };

        serialStdio = mkOption {
          type = types.bool;
          default = false;
          description = "Attach serial to stdio (debugging)";
        };

      };
    }));

    default = {};
  };

  config = mkMerge [

    {
      virtualisation.kvm.enable = true;

      security.wrappers.qemu-bridge-helper = {
        source = "${pkgs.qemu_kvm}/libexec/qemu-bridge-helper";
        capabilities = "cap_net_admin+ep";
      };

      environment.etc."qemu/bridge.conf".text =
        concatMapStringsSep "\n" (b: "allow ${b}") allBridges;
    }

    (mapAttrsToList (name: vm:

      mkIf vm.enable (

        let
          qmpSocket = "/run/vm-${name}-qmp.sock";

          qmpFlag =
            optionalString vm.enableQmp
              "-qmp unix:${qmpSocket},server,nowait";

          serialFlags = concatStringsSep " \\\n" (filter (x: x != "") [

            (optionalString vm.enableSerial
              "-serial unix:${serialSocket},server,nowait")

            (optionalString vm.serialStdio
              "-serial mon:stdio")

          ]);

        in
        {

          systemd.services."vm-${name}" = {
            description = "QEMU VM ${name}";

            after = [
              "network-online.target"
              "local-fs.target"
              "remote-fs.target"
            ];

            wants = [
              "network-online.target"
            ];

            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
              ExecStart = ''
                ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 \
                  ${vm.qemuArgs} \
                  ${serialFlags} \
                  ${qmpFlag}
              '';

              ExecStop =
                optionalString vm.enableQmp ''
                  if [ -S "${qmpSocket}" ]; then
                    echo '{ "execute": "system_powerdown" }' \
                      | ${pkgs.socat}/bin/socat - UNIX-CONNECT:${qmpSocket}
                  fi
                '';

              Restart = "always";
              RestartSec = 5;

              NoNewPrivileges = true;
              CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
              AmbientCapabilities = [ "CAP_NET_ADMIN" ];
            };
          };

        }
      )
    ) cfg)

  ];
}
```

```nix
virtualisation.vms."vyos" = {
  enable = true;
  bridgeAllow = [ "br-lan" ];
  enableQmp = true;
  enableSerial = true;
  serialStdio = false;
  qemuArgs = ''
    -enable-kvm \
    -cpu host \
    -smp 2 \
    -m 2048 \
    -drive file=/var/lib/libvirt/images/linux2024.qcow2,format=qcow2,if=virtio \
    -netdev bridge,helper=/run/wrappers/bin/qemu-bridge-helper,id=net0,br=br-lan \
    -device virtio-net-pci,netdev=net0,mac=52:54:00:91:9e:a2 \
    -netdev bridge,helper=/run/wrappers/bin/qemu-bridge-helper,id=net1,br=br-lan \
    -device virtio-net-pci,netdev=net1,mac=52:54:00:dc:37:3c \
    -nographic \
    -serial mon:stdio \
    -serial pty
  '';
};
```
