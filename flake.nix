{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, microvm, sops-nix, ... }@inputs: {
    nixosConfigurations."host" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs microvm sops-nix; };
      modules = [
        ./roles/base/default.nix
        ./roles/server/default.nix
        ./hosts/host/default.nix
        ./microvm/default.nix
        ./secrets/default.nix
      ];
    };
  };
}
