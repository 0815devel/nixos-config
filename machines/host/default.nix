{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./zfs.nix
      ./network.nix
      ./firewall.nix
      ./nfs.nix
      ./libvirt.nix
      ./packages.nix
      ../../profiles/base
      ../../profiles/headless
      ../../profiles/nix
      ../../microvm
      ../../secrets
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  boot.kernelParams = [
    "pcie_aspm=powersave" # Enable ASPM in power-saving mode
    "intel_pstate=enable" # Enable dynamic CPU frequency scaling
  ];

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = false;
    operation = "switch";
    flake = "/etc/nixos";
    flags = [
      "--recreate-lock-file"
      "--commit-lock-file"
      "-L"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  programs.nix-ld.enable = true;

  system.configurationRevision = inputs.self.rev or "dirty";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
