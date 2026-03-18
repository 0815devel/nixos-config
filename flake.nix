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
    pkgs = import nixpkgs { inherit system; };
  in
  {
    nixosConfigurations."host" = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs microvm sops-nix; };
      modules = [
        ./roles/base
        ./roles/server
        ./hosts/host
        ./microvm
        ./secrets
      ];
    };
  };
}
