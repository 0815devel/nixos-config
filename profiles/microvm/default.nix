{ ... }:

{
  imports = [
    ./users.nix
  ];

  users.users.root.hashedPassword = "!";
}
