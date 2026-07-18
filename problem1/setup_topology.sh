#!/usr/bin/env bash
set -e

# Clear existing configuration if rerun
ip netns del node1 2>/dev/null || true
ip netns del node2 2>/dev/null || true
ip netns del node3 2>/dev/null || true
ip netns del node4 2>/dev/null || true
ip netns del router 2>/dev/null || true

ip link del br1 2>/dev/null || true
ip link del br2 2>/dev/null || true

echo "Creating Network Namespaces..."
ip netns add node1
ip netns add node2
ip netns add node3
ip netns add node4
ip netns add router

echo "Creating Linux Bridges in Root Namespace..."
ip link add br1 type bridge
ip link add br2 type bridge
ip link set br1 up
ip link set br2 up

echo "Connecting Node 1 & Node 2 to Bridge 1..."
# node1 <-> br1
ip link add veth-node1 type veth peer name veth-br1-1
ip link set veth-node1 netns node1
ip link set veth-br1-1 master br1
ip netns exec node1 ip addr add 172.0.0.2/24 dev veth-node1
ip netns exec node1 ip link set veth-node1 up
ip netns exec node1 ip link set lo up
ip link set veth-br1-1 up

# node2 <-> br1
ip link add veth-node2 type veth peer name veth-br1-2
ip link set veth-node2 netns node2
ip link set veth-br1-2 master br1
ip netns exec node2 ip addr add 172.0.0.3/24 dev veth-node2
ip netns exec node2 ip link set veth-node2 up
ip netns exec node2 ip link set lo up
ip link set veth-br1-2 up

echo "Connecting Node 3 & Node 4 to Bridge 2..."
# node3 <-> br2
ip link add veth-node3 type veth peer name veth-br2-3
ip link set veth-node3 netns node3
ip link set veth-br2-3 master br2
ip netns exec node3 ip addr add 10.10.0.2/24 dev veth-node3
ip netns exec node3 ip link set veth-node3 up
ip netns exec node3 ip link set lo up
ip link set veth-br2-3 up

# node4 <-> br2
ip link add veth-node4 type veth peer name veth-br2-4
ip link set veth-node4 netns node4
ip link set veth-br2-4 master br2
ip netns exec node4 ip addr add 10.10.0.3/24 dev veth-node4
ip netns exec node4 ip link set veth-node4 up
ip netns exec node4 ip link set lo up
ip link set veth-br2-4 up

echo "Connecting Router to Bridges..."
# Router <-> br1
ip link add veth-r-br1 type veth peer name veth-br1-r
ip link set veth-r-br1 netns router
ip link set veth-br1-r master br1
ip netns exec router ip addr add 172.0.0.1/24 dev veth-r-br1
ip netns exec router ip link set veth-r-br1 up
ip link set veth-br1-r up

# Router <-> br2
ip link add veth-r-br2 type veth peer name veth-br2-r
ip link set veth-r-br2 netns router
ip link set veth-br2-r master br2
ip netns exec router ip addr add 10.10.0.1/24 dev veth-r-br2
ip netns exec router ip link set veth-r-br2 up
ip link set veth-br2-r up

ip netns exec router ip link set lo up

echo "Enabling IP Forwarding in Router Namespace..."
ip netns exec router sysctl -w net.ipv4.ip_forward=1 > /dev/null

echo "Setting Default Gateways for Nodes..."
ip netns exec node1 ip route add default via 172.0.0.1
ip netns exec node2 ip route add default via 172.0.0.1
ip netns exec node3 ip route add default via 10.10.0.1
ip netns exec node4 ip route add default via 10.10.0.1

echo "Topology setup complete successfully!"
