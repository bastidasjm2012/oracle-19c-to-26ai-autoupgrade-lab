#!/bin/bash

OUT=/root/evidence/phase00_lab_build

echo "Collecting Oracle Linux baseline..."

cat /etc/oracle-release \
> $OUT/01_os_release.log

hostnamectl \
> $OUT/02_hostname.log

uname -a \
> $OUT/03_kernel.log

lsblk \
> $OUT/04_disk_layout.log

df -h \
> $OUT/05_filesystem.log

free -h \
> $OUT/06_memory.log

lscpu \
> $OUT/07_cpu.log

ip addr \
> $OUT/08_network.log

echo "Completed."
