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
  outputs = { self, nixpkgs, microvm, sops-nix, ... }@inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations."host" = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs microvm sops-nix; };
      modules = [ ./machines/host ];
    };
  };
}
