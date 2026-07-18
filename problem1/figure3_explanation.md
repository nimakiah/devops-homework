# Figure 3 Explanation: Cross-Server Namespace Networking

To route packets between subnets across two physical/virtual servers connected via L2:

## Approach 1: Static IP Routes over L2 Physical Interface
1. Server 1 (`192.168.1.10`) routes `10.10.0.0/24` via Server 2 IP (`192.168.1.20`).
2. Server 2 (`192.168.1.20`) routes `172.0.0.0/24` via Server 1 IP (`192.168.1.10`).
3. Enable `net.ipv4.ip_forward=1` on both servers.

## Approach 2: VXLAN Overlay Network
Create a VXLAN overlay tunnel spanning `Server1` and `Server2` to encapsulate container traffic over UDP across the L2 switch.
