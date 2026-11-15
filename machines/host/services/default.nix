{ ... }:

{
  imports = [
    ./ssh.nix
    #./unbound.nix
    ./dnsmasq.nix
    ./ddclient.nix
    ./libvirt.nix
    ./nfs.nix
    ./avahi.nix
  ];
}
