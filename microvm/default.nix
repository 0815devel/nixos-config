{ microvm, ... }:

{
  imports = [
    microvm.nixosModules.host
    ./microvm-network.nix
  ];
  microvm.vms.foo.config = {
    imports = [
      ./foo/default.nix
      ../common/default.nix
    ];
  };
  microvm.vms.bar.config = {
    imports = [
      ./bar/default.nix
      ../common/default.nix
    ];
  };
}
