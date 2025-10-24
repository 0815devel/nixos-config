{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  ########################################
  # Boot & ZFS
  ########################################
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enable = true;
  boot.zfs.pools = [ "tank" ];

  # Kernel parameters for power management
  boot.kernelParams = [
    "pcie_aspm=powersave"  # Enable ASPM in power-saving mode
    "intel_pstate=enable"  # Enable dynamic CPU frequency scaling
  ];

  # Enable nested virtualization for Intel KVM only
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
  '';

  ########################################
  # Users
  ########################################
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirt" ]; # sudo + libvirt permissions
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBLA..." # your public key
    ];
  };

  ########################################
  # SSH Server
  ########################################
  services.openssh = {
    enable = true;
    settings = {
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
  };

  ########################################
  # CPU / Power Saving
  ########################################
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave"; # CPU frequency governor set to powersave

  ########################################
  # Network (Bridge & VLAN)
  ########################################
  networking = {
    hostName = "hypervisor.internal";
    useDHCP = false;

    bridges.br0.interfaces = [ "enp3s0" ]; # Adjust to your physical NIC

    interfaces."br0" = {
      ipv4.addresses = [ { address = "10.0.0.2"; prefixLength = 24; } ];
    };

    vlans."br0.7" = {
      id = 7;
      interface = "br0";
    };

    defaultGateway = "10.0.0.1";
    nameservers = [ "10.0.0.1" ];
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
  # NFS Server
  ########################################

  {
    services.nfs.server.enable = true;
    services.nfs.server.exports = ''
      /export 192.168.1.10(rw,fsid=0,no_subtree_check)
    '';
  }

  ########################################
  # Locale / Keyboard / Time
  ########################################
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  ########################################
  # System Packages
  ########################################
  environment.systemPackages = with pkgs; [
    vim
    htop
    zfs
    git
    cpupower
  ];
}
