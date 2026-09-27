# Syncoid Pull Backup — NixOS Configuration

## Setup

| System                    | Role                             |
| ------------------------- | -------------------------------- |
| `host`                    | Source                           |
| `backup`                  | Backup server                    |
| `tank`                    | ZFS pool on `host`               |
| `syncoid`                 | Dedicated SSH/ZFS user and group |
| `/run/secrets/ssh-privat` | SSH private key                  |

The backup server pulls snapshots from `host`.

## Backup Server (`backup`)

```nix
services.syncoid = {
  enable = true;

  user = "syncoid";
  group = "syncoid";

  sshKey = "/run/secrets/ssh-privat";

  commonArgs = [
    "--no-sync-snap"
    "--no-rollback"
  ];

  localTargetAllow = [
    "create"
    "mount"
    "receive"
  ];

  commands = {
    "syncoid@host:tank".target = "tank";
  };
};
```

## Source Server (`host`)

Grant the `syncoid` user permission to send the ZFS dataset:

```bash
sudo zfs allow -u syncoid send tank
```

If holds are required:

```bash
sudo zfs allow -u syncoid send,hold tank
```

## Snapshot Policy

### Source: `host`

* Snapshots are managed independently.
* Existing source retention policy remains unchanged.
* Syncoid does not create synchronization snapshots.
* Syncoid does not manage source snapshot retention.

### Backup: `backup`

* Snapshots are managed independently.
* Monthly snapshots are retained for 12 months.
* Syncoid does not delete backup snapshots.
* Syncoid does not roll back the backup dataset.
* The backup server's snapshot retention is independent of the source.

## Syncoid Behavior

```text
host:tank
    │
    │  SSH / syncoid
    │
    ▼
backup:tank
```

* Pull missing snapshots from `host`.
* Preserve existing snapshots on `backup`.
* Transfer intermediate snapshots when required.
* Never automatically delete backup snapshots.
* Never automatically roll back the backup dataset.
* Do not create additional synchronization snapshots on `host`.
* Do not use `--no-stream`.
* Do not use `--delete-target-snapshots`.
