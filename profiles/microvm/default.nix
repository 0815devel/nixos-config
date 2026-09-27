{ ... }:

{
  imports = [
    ./users.nix
    ./ssh.nix
  ];

  microvm.registerWithMachined = true;
}
