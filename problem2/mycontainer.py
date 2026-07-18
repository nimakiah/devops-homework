#!/usr/bin/env python3
import sys
import os
import ctypes
import shutil
import subprocess

# Linux clone flags for creating unshare namespaces
CLONE_NEWNS   = 0x00020000  # Mount namespace
CLONE_NEWUTS  = 0x04000000  # UTS (hostname) namespace
CLONE_NEWPID  = 0x20000000  # PID namespace
CLONE_NEWNET  = 0x40000000  # Network namespace

libc = ctypes.CDLL("libc.so.6")

def apply_memory_limit(mem_mb):
    """Bonus Feature: Limit container memory usage using Cgroups v2."""
    cg_path = "/sys/fs/cgroup/mycontainer"
    os.makedirs(cg_path, exist_ok=True)
   
    mem_bytes = int(mem_mb) * 1024 * 1024
    with open(f"{cg_path}/memory.max", "w") as f:
        f.write(str(mem_bytes))
       
    with open(f"{cg_path}/cgroup.procs", "w") as f:
        f.write(str(os.getpid()))

def run_container_child(hostname, mem_limit=None):
    # Apply memory limit if specified
    if mem_limit:
        try:
            apply_memory_limit(mem_limit)
        except Exception as e:
            print(f"[Warning] Failed to set memory limit: {e}")

    # Set UTS Hostname
    libc.sethostname(hostname.encode(), len(hostname))

    # Isolate root filesystem for this container
    base_dir = os.path.dirname(os.path.abspath(__file__))
    base_rootfs = os.path.join(base_dir, "ubuntu_rootfs")
    container_rootfs = os.path.join(base_dir, f"containers_rootfs/{hostname}")

    if not os.path.exists(container_rootfs):
        print(f"Creating dedicated rootfs copy for '{hostname}'...")
        shutil.copytree(base_rootfs, container_rootfs, symlinks=True)

    # Change root directory to container rootfs
    os.chroot(container_rootfs)
    os.chdir("/")

    # Mount /proc filesystem inside container (ensures PID 1 visibility)
    os.makedirs("/proc", exist_ok=True)
    subprocess.run(["mount", "-t", "proc", "proc", "/proc"], check=False)

    # Start interactive bash shell inside container
    os.execv("/bin/bash", ["/bin/bash"])

def main():
    if len(sys.argv) < 2:
        print("Usage: sudo ./mycontainer.py <hostname> [memory_limit_mb]")
        sys.exit(1)

    hostname = sys.argv[1]
    mem_limit = sys.argv[2] if len(sys.argv) > 2 else None

    # Step 1: Unshare namespaces (MNT, UTS, PID, NET)
    res = libc.unshare(CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWPID | CLONE_NEWNET)
    if res != 0:
        print("Error: Failed to unshare namespaces. Ensure you run with 'sudo'.")
        sys.exit(1)

    # Step 2: Fork process to instantiate PID 1 in the new PID namespace
    pid = os.fork()
    if pid == 0:
        run_container_child(hostname, mem_limit)
    else:
        _, status = os.waitpid(pid, 0)
        sys.exit(status >> 8)

if __name__ == "__main__":
    main()
