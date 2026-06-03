# Phase 00 - Oracle Linux 7.9 Base Build Evidence

## Project

Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab using AutoUpgrade Utility.

This phase documents the creation, validation and evidence collection of the source operating system before installing Oracle Database 19c.

The objective is to provide a clean, validated and recoverable baseline environment before starting the database upgrade lifecycle.

---

# Architecture Overview

```text
VMware Workstation Pro 17.5
            |
            |
            v
Oracle Linux Server 7.9
            |
            |
            v
Oracle Database 19c Enterprise Edition
            |
            |
            v
NEXUS Non-CDB Database
            |
            |
            v
Oracle AI Database 26ai Upgrade
```

---

# Virtual Machine Configuration

| Component | Value |
|---------|-------|
| Hypervisor | VMware Workstation Pro 17.5 |
| VM Name | OL79_ORACLE19C_TO_26AI_LAB |
| Hostname | srvdb19c |
| Operating System | Oracle Linux Server 7.9 |
| Kernel | 3.10.0-1160.el7.x86_64 |
| Architecture | x86_64 |
| CPU | 4 cores |
| Memory | 12 GB |
| Disk | 160 GB |
| Disk Controller | SCSI |
| Network | NAT |

---

# Operating System Validation

## OS Release

Command:

```bash
cat /etc/oracle-release
```

Result:

```text
Oracle Linux Server release 7.9
```

Evidence:

```text
01_os_release.log
```

Status:

```text
PASSED
```

---

# Host Configuration

Command:

```bash
hostnamectl
```

Expected:

```text
Static hostname: srvdb19c
```

Evidence:

```text
02_hostname.log
```

Status:

```text
PASSED
```

---

# Kernel Baseline

Command:

```bash
uname -r
```

Result:

```text
3.10.0-1160.el7.x86_64
```

Evidence:

```text
03_kernel.log
```

Status:

```text
PASSED
```

---

# Storage Layout

Command:

```bash
lsblk
```

Disk layout:

```text
sda 160G

├── sda1   /boot    2GB
├── sda2   /        50GB
├── sda3   swap     16GB
└── sda5   /u01     92GB
```

Oracle filesystem strategy:

```text
/u01

├── Oracle Software
├── Oracle Inventory
├── Oracle Database Files
├── RMAN Backups
└── AutoUpgrade Files
```

Evidence:

```text
04_disk_layout.log
05_filesystem.log
```

Status:

```text
PASSED
```

---

# CPU Validation

Command:

```bash
lscpu
```

Configuration:

```text
CPU(s): 4
Socket(s): 1
Core(s) per socket: 4
```

Evidence:

```text
07_cpu.log
```

Status:

```text
PASSED
```

---

# Memory Validation

Command:

```bash
free -h
```

Configuration:

```text
RAM : 12 GB
Swap: 16 GB
```

Evidence:

```text
06_memory.log
```

Status:

```text
PASSED
```

---

# Network Validation

Interface:

```text
ens33
```

IP Address:

```text
192.168.197.129
```

Hosts configuration:

```text
192.168.197.129 srvdb19c.localdomain srvdb19c
```

Command:

```bash
ping srvdb19c
```

Result:

```text
0% packet loss
```

Evidence:

```text
08_network.log
09_hosts_resolution.log
```

Status:

```text
PASSED
```

---

# Evidence Repository Structure

```text
phase00_lab_build/

├── 01_os_release.log
├── 02_hostname.log
├── 03_kernel.log
├── 04_disk_layout.log
├── 05_filesystem.log
├── 06_memory.log
├── 07_cpu.log
├── 08_network.log
├── 09_hosts_resolution.log
│
├── capture_phase00.sh
│
├── ol79_initial_baseline.log
│
├── phase00_validation_report.txt
│
└── README.md
```

---

# Rollback Strategy

Before installing Oracle Database 19c prerequisites, a VMware snapshot was created.

Snapshot Name:

```text
OL79_BASE_INSTALL_CLEAN
```

Snapshot Information:

```text
Oracle Linux Server 7.9

Hostname:
srvdb19c

CPU:
4 cores

Memory:
12 GB

Disk:
160 GB SCSI

Partitions:

/boot
/
/u01
swap
```

Purpose:

```text
Rollback point before:

- Oracle prerequisites installation
- Oracle user creation
- Kernel parameter changes
- Oracle Database software installation
```

Rollback status:

```text
AVAILABLE
```

---

# Phase 00 Validation Checklist

| Validation | Status |
|---|---|
| Oracle Linux 7.9 Installation | PASSED |
| VMware configuration | PASSED |
| Hostname configuration | PASSED |
| Network resolution | PASSED |
| Disk layout validation | PASSED |
| CPU validation | PASSED |
| Memory validation | PASSED |
| Evidence collection | PASSED |
| VMware Snapshot | PASSED |

---

# GO / NO-GO Decision

```text
====================================

PHASE 00 RESULT

STATUS:

GO


READY FOR:

Oracle Database 19c Environment Preparation


NEXT PHASE:

Phase 01

Install Oracle Database 19c prerequisites

====================================
```

---

# Next Phase

Phase 01 - Oracle Database 19c Environment Preparation

Tasks:

- Configure Oracle Linux packages
- Install oracle-database-preinstall-19c
- Validate kernel parameters
- Configure Oracle user
- Prepare Oracle filesystem
- Stage Oracle Database 19c software
