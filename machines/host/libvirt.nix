{ config, pkgs, ... }:

{

  users.users."admin".extraGroups = [ "libvirtd" ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };

  boot = {
    #kernelParams = [
      #"intel_iommu=on" # Enable IOMMU
      #"iommu=pt" # Performance for IOMMU
      #"vfio-pci.ids=1002:67b0,1002:aac8" # IDs of PCIe devices to passthrough
    #];

    #kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ]; # VFIO modules for PCIe Passthrough

    extraModprobeConfig = ''
      options kvm_intel nested=1
    '';
  };
}
