{ self, config, pkgs, microvm, ... }:

{
  ########################################
  # VMs
  ########################################
  microvm.vms.test = {
    flake = self;
    updateFlake = "git+file:///etc/nixos";
    autostart = true;
    restartIfChanged = true;
  };
  microvm.vms.foo = {
    flake = self;
    updateFlake = "git+file:///etc/nixos";
    autostart = true;
    restartIfChanged = true;
  };
}
