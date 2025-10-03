```nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot & ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enable = true;
  boot.zfs.pools = [ "tank" ];

  # Benutzer
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirt" ]; # sudo + libvirt Rechte
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLA..."  # hier deinen Key einfügen
    ];
  };

  # Root Passwort optional (Key-basiert empfohlen)
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIRootKey..."  # optional
  ];

  # SSH Server
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  # Libvirt / KVM
  virtualisation.libvirtd = {
    enable = true;
    extraGroups = [ "wheel" "libvirt" ];
    listenAll = true;    # optional für Remote
    tls = false;         # TLS optional
    network.enable = true; # Standard-Netzwerk erstellen
    virtlockd.enable = true;
    virtlogd.enable = true;
    cgroupSupport = true;
  };
  virtualisation.qemu.package = pkgs.qemu_kvm;

  # Nützliche Pakete
  environment.systemPackages = with pkgs; [
    vim
    htop
    zfs
    git
  ];

  # Zeit & Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
}
```