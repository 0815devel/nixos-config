{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
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
  # Users and Groups
  ########################################
  users.groups.admin = {
    gid = 1000;
  };

  users.users.admin = {
    uid = 1000;
    isNormalUser = true;
    group = "admin";
    extraGroups = [ "wheel" "libvirtd" ];
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
      /tank 10.0.0.127(rw,sync,no_subtree_check)
      /tank/podman 10.0.1.2(rw,sync,no_subtree_check,no_root_squash)
      /tank/media 10.0.1.2(ro,sync,no_subtree_check,no_root_squash)
    '';
  };

  ########################################
  # Network (Bridge & VLAN) & Firewall
  ########################################
  systemd.network = {
    enable = true;
    netdevs = {
      "br-lan" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-lan";
         };
       };
      "br-wan" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-wan";
         };
       };
      "br-nfs" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br-nfs";
         };
       };
      "lan-nic0-vlan7" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "lan-nic0.7";
        };
        vlanConfig.Id = 7;
      };
    };
    networks = {
      "lan-onboard" = {
        matchConfig.MACAddress = "9c:6b:00:39:c9:ce";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "lan-nic0" = {
        matchConfig.MACAddress = "a0:36:9f:83:e8:10";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
        vlan = [ "lan-nic0.7" ];
      };
      "lan-nic1" = {
        matchConfig.MACAddress = "a0:36:9f:83:e8:11";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "lan-nic2" = {
        matchConfig.MACAddress = "a0:36:9f:83:e8:12";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "lan-nic3" = {
        matchConfig.MACAddress = "a0:36:9f:83:e8:13";
        networkConfig.Bridge = "br-lan";
        linkConfig.RequiredForOnline = "enslaved";
      };
      "lan-nic0.7" = {
        matchConfig.Name = "lan-nic0.7";
        networkConfig.Bridge = "br-wan";
        linkConfig.RequiredForOnline = "carrier";
      };
      "br-lan" = {
        matchConfig.Name = "br-lan";
        address = [ "10.0.0.3/24" ];
        dns = [ "10.0.0.1" "1.1.1.1" ];
        domains = [ "internal" ];
        gateway = [ "10.0.0.1" ];
      };
      "br-wan" = {
        matchConfig.Name = "br-wan";
        linkConfig.ActivationPolicy = "always-up";
        networkConfig = { 
          ConfigureWithoutCarrier = true;
        };
      };
      "br-nfs" = {
        matchConfig.Name = "br-nfs";
        address = [ "10.0.1.1/24" ];
        linkConfig.ActivationPolicy = "up";
        networkConfig = { 
          ConfigureWithoutCarrier = true;
        };
      };
    };
  };

  networking = {
    hostName = "hypervisor";
    domain = "internal";
    useDHCP = false;
    hostId = "4e98920d";

    firewall = {
      enable = true;
      allowPing = true;
      rejectPackets = true;

      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];

      interfaces = {
        "br-lan" = {
          allowedTCPPorts = [ 22 2049 ]; # SSH and NFS
          allowedUDPPorts = [ 2049 ]; # NFS
        };
        "br-nfs" = {
          allowedTCPPorts = [ 2049 ]; # NFS
          allowedUDPPorts = [ 2049 ]; # NFS
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
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
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
    dates = "weekly";
    allowReboot = false;
    operation = "switch"; 
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  #nix.settings.auto-optimise-store = true;

  ########################################
  # System Packages
  ########################################
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    htop
    zfs
    git
    pciutils
    lshw
    ethtool
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
