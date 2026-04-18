```nix
{
  
  users.users."vyos" = {
    isSystemUser = true;
    group = "vyos";
  };
  
  users.groups.vyos = {};
  
  users.users.vyos.extraGroups = [ "kvm" ];
  
  environment.systemPackages = [
    pkgs.qemu_kvm
  ];
  
  virtualisation.kvm.enable = true;
  
  security.wrappers.qemu-bridge-helper = {
    source = "${pkgs.qemu_kvm}/libexec/qemu-bridge-helper";
    capabilities = "cap_net_admin+ep";
  };
  
  environment.etc."qemu/bridge.conf".text = ''
    allow br-lan
  '';
  
  systemd.services.vyos = {
    description = "VyOS VM (QEMU)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
      AmbientCapabilities = [ "CAP_NET_ADMIN" ];
      NoNewPrivileges = true;
      User = "vyos";
      Group = "vyos";
      ExecStart = ''
        ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 \
          -enable-kvm \
          -cpu host \
          -smp 2 \
          -m 2048 \
          -drive file=/var/lib/libvirt/images/linux2024.qcow2,format=qcow2,if=virtio \
          -netdev bridge,helper=/run/wrappers/bin/qemu-bridge-helper,id=net0,br=br-lan \
          -device virtio-net-pci,netdev=net0,mac=52:54:00:91:9e:a2 \
          -netdev bridge,helper=/run/wrappers/bin/qemu-bridge-helper,id=net1,br=br-lan \
          -device virtio-net-pci,netdev=net1,mac=52:54:00:dc:37:3c \
          -nographic
          -serial mon:stdio
          -qmp unix:/run/vyos-qmp.sock,server,nowait
      '';
      ExecStop = ''
        echo '{ "execute": "system_powerdown" }' \
          | ${pkgs.socat}/bin/socat - UNIX-CONNECT:/run/vyos-qmp.sock
      '';      
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
```

```nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.vms;

  mkVM = name: vm:
    let
      netdevs = imap0 (i: net:
        ''
          -netdev bridge,helper=/run/wrappers/bin/qemu-bridge-helper,id=net${toString i},br=${net.bridge} \
          -device virtio-net-pci,netdev=net${toString i}${optionalString (net.mac != null) ",mac=${net.mac}"} \
        ''
      ) vm.bridges;

      qemuCmd = ''
        ${pkgs.qemu_kvm}/bin/qemu-system-x86_64 \
          -enable-kvm \
          -cpu host \
          -smp ${toString vm.vcpus} \
          -m ${toString vm.memory} \
          -drive file=${vm.disk},format=qcow2,if=virtio \
          ${concatStringsSep "\n" netdevs} \
          -nographic \
          -qmp unix:/run/${name}-qmp.sock,server,nowait
      '';
    in
    {
      systemd.services."vm-${name}" = {
        description = "VM ${name}";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = vm.user;
          Group = vm.group;

          ExecStart = qemuCmd;

          ExecStop = ''
            echo '{ "execute": "system_powerdown" }' \
              | ${pkgs.socat}/bin/socat - UNIX-CONNECT:/run/${name}-qmp.sock
          '';

          Restart = "on-failure";
          RestartSec = 5;

          NoNewPrivileges = true;
          CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
          AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        };
      };
    };

in
{
  options.virtualisation.vms = mkOption {
    type = types.attrsOf (types.submodule ({ name, ... }: {
      options = {
        enable = mkEnableOption "VM ${name}";

        memory = mkOption {
          type = types.int;
          default = 1024;
        };

        vcpus = mkOption {
          type = types.int;
          default = 1;
        };

        disk = mkOption {
          type = types.str;
        };

        user = mkOption {
          type = types.str;
          default = "vm-${name}";
        };

        group = mkOption {
          type = types.str;
          default = "vm-${name}";
        };

        bridges = mkOption {
          type = types.listOf (types.submodule {
            options = {
              bridge = mkOption { type = types.str; };
              mac = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
            };
          });
          default = [];
        };
      };
    }));
    default = {};
  };

  config = mkMerge (
    mapAttrsToList (name: vm:
      mkIf vm.enable (mkMerge [
        (mkVM name vm)

        {
          users.users.${vm.user} = {
            isSystemUser = true;
            group = vm.group;
            extraGroups = [ "kvm" ];
          };

          users.groups.${vm.group} = {};

          environment.etc."qemu/bridge.conf".text =
            concatStringsSep "\n" (map (b: "allow ${b.bridge}") vm.bridges);
        }
      ])
    ) cfg
  );
}
```

```nix
{
  imports = [
    ./modules/vm.nix
  ];

  virtualisation.vms.vyos = {
    enable = true;
    memory = 2048;
    vcpus = 2;

    disk = "/var/lib/libvirt/images/linux2024.qcow2";

    bridges = [
      { bridge = "br-lan"; mac = "52:54:00:91:9e:a2"; }
      { bridge = "br-lan"; mac = "52:54:00:dc:37:3c"; }
    ];
  };
}
```
