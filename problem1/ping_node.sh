#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_node> <target_node>"
    echo "Example: $0 node1 router"
    echo "Example: $0 node1 node3"
    exit 1
fi

SRC_NODE="$1"
DST_NODE="$2"

declare -A IP_MAP
IP_MAP["node1"]="172.0.0.2"
IP_MAP["node2"]="172.0.0.3"
IP_MAP["node3"]="10.10.0.2"
IP_MAP["node4"]="10.10.0.3"
IP_MAP["router"]="172.0.0.1" # Default to sub1 IP for router pinging

if [ -z "${IP_MAP[$SRC_NODE]}" ]; then
    echo "Error: Source node '$SRC_NODE' is invalid."
    exit 1
fi

if [ -z "${IP_MAP[$DST_NODE]}" ]; then
    echo "Error: Target node '$DST_NODE' is invalid."
    exit 1
fi

TARGET_IP="${IP_MAP[$DST_NODE]}"

echo "Executing ping from $SRC_NODE to $DST_NODE ($TARGET_IP)..."
ip netns exec "$SRC_NODE" ping -c 4 "$TARGET_IP"
