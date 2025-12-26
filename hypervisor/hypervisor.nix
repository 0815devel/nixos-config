{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./users.nix
      ./packages.nix
      ./network.nix
      ./ssh.nix
      ./nfs.nix
      ./libvirt.nix
    ];

  ########################################
  # Boot & ZFS
  ########################################
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "tank" ];

    # Kernel parameters
    kernelParams = [
      "pcie_aspm=powersave" # Enable ASPM in power-saving mode
      "intel_pstate=enable" # Enable dynamic CPU frequency scaling
      "zfs.zfs_arc_max=4294967296" # ARC 4GiB max
      "intel_iommu=on" # Enable IOMMU
      #"iommu=pt" # Performance for IOMMU
      #"vfio-pci.ids=1002:67b0,1002:aac8" # IDs of PCIe devices to passthrough
    ];

    # PCIe passthrough
    kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];

    # Enable nested virtualization
    extraModprobeConfig = ''
      options kvm_intel nested=1
    '';
  };

  ########################################
  # CPU / Power Saving
  ########################################
  #powerManagement = {
  #  enable = true;
  #  cpuFreqGovernor = "ondemand";
  #};

  ########################################
  # Services
  ########################################
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
    autoSnapshot.enable = true;
  };

  ########################################
  # Locale / Keyboard / Time
  ########################################
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  ########################################
  # Automatic Updates & Nix
  ########################################
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = false;
    operation = "switch"; 
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
      "-L"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  #nix.settings.auto-optimise-store = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
