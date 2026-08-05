# nixos-config

This repository contains my personal [NixOS](https://nixos.org) configuration, managed with **Nix Flakes**.

## Repository Structure

```
.
├── flake.nix # Main flake definition
├── flake.lock # Flake lockfile
├── machines/ # Physical machines
├── microvm/ # MicroVM machines with services
├── profiles/ # Shared profiles for hosts and MicroVMs
├── secrets/ # Encrypted secrets (managed with SOPS)
```


### Hosts

Each machine has its own directory under `machines/`:

- **machines/host/** – The hypervisor and router
  - `default.nix` – Main NixOS configuration
  - `firewall/` – Firewall rules (nftables)
    - `filter.nix` - Filter rules
    - `nat.nix` - NAT rules
  - `network/` – Network configuration
    - `default.nix` - Host and domain name; sysctl forwarding
    - `interfaces.nix` - Interface and VLAN configuration
    - `netdevs.nix` - Virtual interfaces
    - `networks.nix` - IP addresses and routing table
    - `wireguard.nix` - VPN configuration
  - `services/` - Configuration of the services
    - `dnsmasq.nix` - DHCP and DNS server
    - `ddclient.nix` - DynDNS client
    - `nfs.nix` - Configuration of NFS exports
    - `libvirt.nix` - Legacy virtualization
  - `hardware-configuration.nix` – Auto-generated hardware config
  - `packages.nix` – Installed packages
  - `zfs.nix` – ZFS configuration

### MicroVMs

The `microvm/` directory contains services running in MicroVMs:

- `default.nix` – Managing all MicroVMs
- `network.nix` – Networking setup
- Each service has its own subdirectory with `default.nix` and `config.nix`:
  - `reverse_proxy/` - Entry to the services
  - `immich/` - Photos
  - `jellyfin/` - Movies and Series
  - `navidrome/` - Music

### Profiles

Shared configurations for different host types:

- `profiles/base/` – Base configuration (locale, hosts)
- `profiles/headless/` – Server-specific roles (SSH, users)
- `profiles/microvm/` – MicroVM-specific roles
- `profiles/nix/` - Nix configuration


### Secrets

Secrets are stored under `secrets/` and encrypted with [SOPS](https://github.com/getsops/sops):

- `default.nix` – Initialization
- `.sops.yaml` – SOPS configuration
- `secrets.yaml` – The actual keys
