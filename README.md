# nixos-config

This repository contains my personal [NixOS](https://nixos.org) configuration, managed with **Nix Flakes**.

## Repository Structure

```
.
├── flake.nix # Main flake definition
├── flake.lock # Flake lockfile
├── hosts/ # Physical machines and laptops
├── microvm/ # MicroVM machines with services
├── roles/ # Shared roles for hosts and services
├── secrets/ # Encrypted secrets (managed with SOPS)
```


### Hosts

Each host has its own directory under `hosts/`:

- **host/** – The hypervisor
  - `default.nix` – Main NixOS configuration
  - `firewall.nix` – Firewall rules
  - `hardware-configuration.nix` – Auto-generated hardware config
  - `libvirt.nix` – Libvirt for legacy VMs
  - `network.nix` – Network configuration
  - `nfs.nix` – NFS setup
  - `packages.nix` – Installed packages
  - `zfs.nix` – ZFS configuration
- **laptop/** – Laptop-specific configuration (coming soon)

### MicroVMs

The `microvm/` directory contains services running in MicroVMs:

- `default.nix` – Managing all MicroVMs
- `network.nix` – Networking setup
- Each service has its own subdirectory with `default.nix` and `config.nix`:
  - `guacamole/`
  - `immich/`
  - `jellyfin/`
  - `minio/`
  - `navidrome/`

### Roles

Shared configurations for different host types:

- `roles/base/` – Base configuration (locale, hosts)
- `roles/server/` – Server-specific roles (SSH, users)
- `roles/microvm/` – MicroVM-specific roles

### Secrets

Secrets are stored under `secrets/` and encrypted with [SOPS](https://github.com/getsops/sops):

- `default.nix` – Initialization
- `minio.nix` – Encryption for `minio`
- `.sops.yaml` – SOPS configuration
- `secrets.yaml` – The actual keys

### Documentation

- [router.md](router.md) – Router configuration
- [services.md](services.md) – Services configuration
