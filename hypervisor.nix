{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  ########################################
  # Boot & ZFS
  ########################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.devNodes = "/dev/disk/by-label/tank";
  boot.zfs.extraPools = [ "tank" ];

  # Kernel parameters for power management
  boot.kernelParams = [
    "pcie_aspm=powersave"  # Enable ASPM in power-saving mode
    "intel_pstate=enable"  # Enable dynamic CPU frequency scaling
  ];

  # Enable nested virtualization for Intel
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
  '';

  ########################################
  # CPU / Power Saving
  ########################################
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";

  ########################################
  # Services
  ########################################

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  ########################################
  # Users
  ########################################
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirt" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIJOwmCsYLHN1/3eG9Qs1Fo9EkCLt7ir/v7AIpL0nvLZ"
    ];
  };

  ########################################
  # SSH Server
  ########################################
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  ########################################
  # NFS Server
  ########################################
  services.nfs.server = {
    enable = true;
    exports = ''
      /tank 10.10.0.2(rw,fsid=0,no_subtree_check)
    '';
  };

  ########################################
  # Network (Bridge & VLAN) & Firewall
  ########################################
  networking = {
    hostName = "hypervisor";
    domain = "internal";
    usePredictableInterfaceNames = true;
    useDHCP = false;
    hostId = "4e98920d";

    defaultGateway = "10.0.0.1";
    nameservers = [ "10.0.0.1" ];

    vlans."enp1s0.7" = {
      id = 7;
      interface = "enp1s0";
    };

    bridges.br-lan.interfaces = [ "enp1s0" ];
    bridges.br-nfs.interfaces = [ ];
    bridges.br-wan.interfaces = [ "enp1s0.7" ];

    interfaces."br-lan" = {
      ipv4.addresses = [ { address = "10.0.0.236"; prefixLength = 24; } ];
    };

    interfaces."br-nfs" = {
      ipv4.addresses = [ { address = "10.10.0.1"; prefixLength = 24; } ];
    };

    firewall = {
      enable = true;
      allowPing = true;

      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];

      interfaces = {
        "br-lan" = {
          allowedTCPPorts = [ 22 ]; # SSH
        };
        "br-nfs" = {
          allowedTCPPorts = [ 2049 ]; # NFS
          allowedUDPPorts = [ 2049 ];
        };
        "br-wan" = {
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
        };
      };
    };
  };

  ########################################
  # Libvirt / QEMU
  ########################################
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm; # VMs run as libvirt-qemu user
      runAsRoot = false;
      swtpm.enable = true;
      ovmf = {
        enable = true; # Enable UEFI firmware for VMs
        packages = [(pkgs.OVMF.override {
          secureBoot = true; # Enable if you want Secure Boot
          tpmSupport = true; # TPM support optional
        }).fd];
      };
    };
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
  # Automatic Updates & Garbage Collection
  ########################################
  system.autoUpgrade = {
    enable = true;
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  system.gc = {
    automatic = true;
    dates = "05:00";
    options = "--delete-generations +10";
  };

  ########################################
  # System Packages
  ########################################
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    htop
    zfs
    git
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
