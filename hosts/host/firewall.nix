{ config, pkgs, ... }:

{
  networking.firewall = {
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
    };
  };
}
