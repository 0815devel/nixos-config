```nix
{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems = [ "zfs" ];

  # ZFS aktivieren
  services.zfs = {
    enable = true;
  };

  # Optional: Pool automatisch importieren
  boot.zfs.enable = true;

  # SSH Zugriff
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false; # besser Schlüssel verwenden
  services.openssh.permitRootLogin = "yes"; # optional
  users.users.youruser = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLA..."
    ];
  };

  # KVM/QEMU Hypervisor
  virtualisation.libvirtd = {
    enable = true;
    extraGroups = [ "wheel" ]; # falls du rootrechte via sudo nutzen willst
  };
  virtualisation.qemu.package = pkgs.qemu_kvm;
}
```