# Phase 01 - Oracle Database 19c OS Preparation Runbook

## Project

Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab using AutoUpgrade Utility

---

## Objective

Prepare Oracle Linux Server 7.9 operating system for Oracle Database 19c installation.

This phase configures the required operating system components before installing Oracle Database binaries.

The script executed in this phase:

```text
scripts/build/01_prepare_os_19c.sh
```

automates:

- Oracle prerequisite packages installation
- Oracle user creation
- Oracle groups validation
- Kernel parameter configuration
- User limits configuration
- Oracle directory structure creation
- Oracle environment variables configuration

---

# Initial Environment

| Component | Value |
|---|---|
| OS | Oracle Linux Server 7.9 |
| Hostname | srvdb19c |
| CPU | 4 cores |
| RAM | 12 GB |
| Oracle Version Target | Oracle Database 19c |
| Database Name | NEXUS |
| Architecture | Non-CDB |

---

# Prerequisites

## Validate OS version

Execute as root:

```bash
cat /etc/oracle-release
```

Expected:

```text
Oracle Linux Server release 7.9
```

---

## Validate hostname

```bash
hostnamectl
```

Expected:

```text
Static hostname: srvdb19c
```

---

## Validate /u01 filesystem

```bash
df -h /u01
```

Expected:

```text
/u01 available
```

---

# Script Location

Create directory:

```bash
mkdir -p /root/scripts/build
```

Script path:

```text
/root/scripts/build/01_prepare_os_19c.sh
```

---

# Create Script

Create the script:

```bash
vi /root/scripts/build/01_prepare_os_19c.sh
```

Paste script content.

Save:

```text
ESC
:wq
```

---

# Assign Execution Permissions

Execute:

```bash
chmod +x /root/scripts/build/01_prepare_os_19c.sh
```

Validate:

```bash
ls -l /root/scripts/build/
```

Expected:

```text
-rwxr-xr-x 01_prepare_os_19c.sh
```

---

# Execute Script

User:

```text
root
```

Execution:

```bash
/root/scripts/build/01_prepare_os_19c.sh
```

---

# Script Actions

## 1. Install Oracle prerequisites

Package:

```bash
oracle-database-preinstall-19c
```

This configures:

- Required RPM packages
- Kernel parameters
- Oracle OS groups
- Oracle user
- Security limits

---

# Oracle User Validation

Command:

```bash
id oracle
```

Expected:

```text
uid=54321(oracle)

gid=54321(oinstall)

groups:

oinstall
dba
oper
backupdba
dgdba
kmdba
racdba
```

Status:

```text
PASSED
```

---

# Oracle Directory Structure

Created:

```text
/u01

├── app
│   └── oracle
│       └── product
│           └── 19
│               └── db_1
│
├── software
│   └── 19c
│
├── backup
│
├── oradata
│
└── stage
    └── 26ai
```

---

# Directory Ownership Validation

Execute:

```bash
ls -ld /u01/app/oracle/product/19/db_1
```

Expected:

```text
oracle oinstall
```

---

# Oracle Environment Validation

Switch user:

```bash
su - oracle
```

Execute:

```bash
env | grep ORACLE
```

Expected:

```text
ORACLE_BASE=/u01/app/oracle

ORACLE_HOME=/u01/app/oracle/product/19/db_1

ORACLE_SID=NEXUS
```

---

# Kernel Parameters Validation

Execute:

```bash
sysctl -a | grep kernel.sem
```

Expected:

```text
kernel.sem = 250 32000 100 128
```

---

# Limits Validation

File:

```text
/etc/security/limits.d/oracle-database-preinstall-19c.conf
```

Validate:

```bash
cat /etc/security/limits.d/oracle-database-preinstall-19c.conf
```

---

# Evidence Location

Execution logs:

```text
/root/evidence/phase01_oracle19c_prepare/
```

Files:

```text
phase01_oracle19c_prepare/

├── 01_prepare_os_19c.sh
├── phase01_validation.log
└── execution_output.log
```

---

# VMware Snapshot

After successful validation create:

sync

sync

shutdown -h now

```text
Snapshot Name:

OL79_ORACLE19C_PREREQS_READY
```

Description:

```text
Oracle Linux 7.9

Oracle Database 19c prerequisites completed

oracle-database-preinstall-19c installed

Oracle User:
oracle

ORACLE_HOME:
/u01/app/oracle/product/19/db_1

Database:
NEXUS

Ready for Oracle 19c software installation
```

---

# GO / NO-GO Checklist

| Validation | Status |
|---|---|
| Oracle preinstall installed | PASSED |
| Oracle user created | PASSED |
| Oracle groups configured | PASSED |
| Kernel parameters configured | PASSED |
| Limits configured | PASSED |
| Oracle directories created | PASSED |
| Environment variables configured | PASSED |

---

# Phase Result

```text
=================================

PHASE 01 STATUS

GO

READY FOR:

Oracle Database 19c Software Installation

=================================
```

---

# Next Phase

Phase 02:

Install Oracle Database 19c Software

Tasks:

- Upload Oracle Database 19c binaries
- Extract software
- Execute runInstaller
- Execute root scripts
- Validate Oracle Home

