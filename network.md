# Network Overview

| Name          | VLAN | Subnet          | Bridge      |
|:--------------|-----:|:----------------|:------------|
| Edge-Router   |    7 | 172.16.255.0/30 | br-edge     |
| LAN           | None | 10.10.10.0/24   | br-lan      |
| Guest         |   20 | 10.10.20.0/24   | br-guest    |
| IoT           |   30 | 10.10.30.0/24   | br-iot      |
| Storage       |  N/A | 10.10.40.0/24   | br-nfs      |
| DMZ           |  N/A | 10.10.50.0/24   | br-dmz      |
| Services      |  N/A | 10.10.60.0/24   | br-services |
| Home VPN	    |  N/A | 10.10.70.0/24   | wg-home     |
| NL VPN	    |  N/A | 10.72.190.93/32 | wg-nld      |

> The hypervisor terminates all VLANs and exposes them internally as Linux bridges. Virtual machines and containers are attached to the appropriate bridge rather than directly to a VLAN.

---

# Network Access Matrix

| Source   | Internet | LAN | Guest | IoT | Storage | DMZ | Services | Backup |
|:---------|:--------:|:---:|:-----:|:---:|:-------:|:---:|:--------:|:------:|
| Internet |    -     | ✖   |  ✖   | ✖    |   ✖     | ✔   |    ✖     |   ✖   |
| LAN      |    ✔     | ✔   |  ✔   | ✔    |   ✔     | ✔   |    ✔    |   ✔   |
| Guest    |    ✔     | ✖   |  ✖   | ✖    |   ✖     | ✔   |    ✖     |   ✖   |
| IoT      |    ✔     | ✖   |  ✖   | ✔    |   ✖     | ✔   |    ✖     |   ✖   |
| Storage  |    ✖     | ✖   |  ✖   | ✖    |   ✔     | ✖   |    ✖     |   ✖   |
| DMZ      |    ✖     | ✖   |  ✖   | ✖    |   ✖     | ✔   |    ✔     |   ✖   |
| Services |    ✔     | ✖   |  ✖   | ✖    |   ✔     | ✖   |    ✔     |   ✖   |
| Home VPN |    ✔     | ✔   |  ✔   | ✔    |   ✔     | ✔  |    ✔     |   ✔   |
| NL VPN   |    ✔     | ✖   |  ✖   | ✖    |   ✖     | ✖   |    ✖     |   ✖   |

> Default policy: deny all, only explicitly required traffic is permitted.

> Guest clients are isolated at the wireless access point (AP Client Isolation).

> Service VMs receive operating system updates through the host and therefore do not require direct Internet access.

> Inter-VLAN routing and firewalling are performed on the hypervisor.
