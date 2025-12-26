{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    microvm.url = "github:microvm-nix/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, microvm, ... }@inputs: {
    nixosConfigurations.hypervisor = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hypervisor/hypervisor.nix
        microvm.nixosModules.host
      ];
    };
  };
}
