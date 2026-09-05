{ ... }:

{
  imports = [
    ./ssh.nix
    ./dnsmasq.nix
    ./ddclient.nix
    ./libvirt.nix
    ./nfs.nix
  ];
}
