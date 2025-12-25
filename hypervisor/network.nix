{ config, pkgs, ... }:

{
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
}
