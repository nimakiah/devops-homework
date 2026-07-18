# Figure 2 Explanation: Inter-Subnet Routing Without a Dedicated Router Namespace

When the dedicated router namespace is removed, routing between `172.0.0.0/24` and `10.10.0.0/24` subnets is handled directly by the Root Network Namespace.

## Root Namespace Routing Configuration
1. Assign Gateway IPs to bridges in root namespace: - `br1`: `172.0.0.1/24` - `br2`: `10.10.0.1/24`
2. Enable kernel forwarding: - `sysctl -w net.ipv4.ip_forward=1`
3. Set node default gateways: - `node1` & `node2` -> `172.0.0.1` - `node3` & `node4` -> `10.10.0.1`
