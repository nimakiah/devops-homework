# Problem2: Custom Container Runtime

This project is a lightweight container runtime written in python. It isolates Linux namespaces (UTS, PID, MNT, NET), sets a custom hostname, changes root filesystem ('chroot'), and optionally limits container memory usage using Cgroups v2.
