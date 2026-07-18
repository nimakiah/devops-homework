# Problem2: Custom Container Runtime

This project is a lightweight container runtime written in python. It isolates Linux namespaces (UTS, PID, MNT, NET), sets a custom hostname, changes root filesystem ('chroot'), and optionally limits container memory usage using Cgroups v2.

# Problem 2: Custom Container Runtime

A simple, zero-dependency container runtime CLI written in Python that provides namespace isolation, custom isolated root filesystems, and memory control limits.

## Features
- **Namespaces Isolated**: `PID`, `UTS`, `MNT`, `NET`.
- **Isolated RootFS**: Extracts Ubuntu 20.04 base rootfs and creates dedicated rootfs copies for every spawned container.
- **PID 1 Verification**: Mounts isolated `/proc` allowing `ps fax` to render bash as `PID 1`.
- **[BONUS] Memory Limits**: Restricts RAM usage via Linux Cgroups v2.

---

## How to Run

### 1. Download Base RootFS
First, run the setup script to fetch Ubuntu 20.04 base image:
```bash
sudo ./setup_rootfs.sh

### 2. Start Container
Run the runtime CLI specifying the target hostname:
sudo ./mycontainer.py myhostname

Inside the container shell, verify hostname and PID status:
hostname
# Output: myhostname

ps fax
# Output: shos /bin/bash as PID 1

### 3. [BONUS]
To cap container RAM at 100MB:
sudo ./mycontainer.py myhostname 100
