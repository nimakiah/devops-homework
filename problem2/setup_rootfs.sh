#!/usr/bin/env bash
set -e

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOTFS_DIR="${BASE_DIR}/ubuntu_rootfs"

if [ -d "$ROOTFS_DIR" ]; then
    echo "Rootfs directory already exists at $ROOTFS_DIR"
    exit 0
fi

echo "Downloading Ubuntu 20.04 Minimal Rootfs..."
mkdir -p "$ROOTFS_DIR"
wget -q https://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.5-base-amd64.tar.gz -O /tmp/ubuntu-base.tar.gz

echo "Extracting Rootfs..."
tar -xzf /tmp/ubuntu-base.tar.gz -C "$ROOTFS_DIR"
rm /tmp/ubuntu-base.tar.gz

echo "Rootfs setup complete!"
