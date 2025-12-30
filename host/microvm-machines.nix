{ self, config, pkgs, microvm, ... }:

{
  ########################################
  # VMs
  ########################################
  microvm.vms.foo = {
    flake = self;
    updateFlake = "git+file:///etc/nixos";
    autostart = true;
    restartIfChanged = true;
  };
  microvm.vms.bar = {
    flake = self;
    updateFlake = "git+file:///etc/nixos";
    autostart = true;
    restartIfChanged = true;
  };
}
