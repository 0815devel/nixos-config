{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      microvm,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations."host" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs microvm; };
        modules = [ ./machines/host ];
      };
    };
}
