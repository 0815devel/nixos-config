{ ... }:

{
  imports = [
    ./users.nix
  ];

  microvm.registerWithMachined = true;
}
