{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, microvm, ... }@inputs: {
    nixosConfigurations.hypervisor = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./common/default.nix
        ./host/default.nix
        microvm.nixosModules.host
        {
          microvm.vms.test = {
            flake = self;
            updateFlake = "git+file:///etc/nixos";
            autostart = true;
            restartIfChanged = true;
          };
        }
      ];
    };
    nixosConfigurations.test = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        microvm.nixosModules.microvm
        ./common/default.nix
        ./microvm/test.nix
      ];
    };
  };
}
