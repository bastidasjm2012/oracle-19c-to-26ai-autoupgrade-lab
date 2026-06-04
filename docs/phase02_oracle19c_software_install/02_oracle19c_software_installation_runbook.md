# Phase 02 - Oracle Database 19c Software Installation

## Project

Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab using AutoUpgrade Utility

---

## Objective

Install Oracle Database 19c Enterprise Edition software only using silent installation mode.

This phase prepares the Oracle 19c Home that will host the source database before:

- Non-CDB creation
- Non-CDB to PDB conversion
- Oracle Linux 7.9 to 8.10 upgrade
- Oracle AI Database 26ai AutoUpgrade

---

# Architecture

```text
Oracle Linux 7.9
        |
        |
        v
Oracle Database Software 19c
        |
        |
        v
ORACLE_HOME

/u01/app/oracle/product/19/db_1
```

---

# Directory Structure

```text
scripts/

└── install_19c/

    ├── 02_install_oracle19c_software.sh
    ├── 03_validate_19c_home.sh
    └── 04_capture_19c_install_evidence.sh


response_files/

└── db_install_19c.rsp


evidence/

└── phase02_oracle19c_software_install/

    ├── install logs
    ├── root_scripts_execution.log
    |
    └── final_validation/

        ├── sqlplus_version.log
        ├── opatch_version.log
        ├── opatch_lsinventory.log
        ├── oracle_home_size.log
        └── orainventory.log
```

---

# Oracle Home Information


| Component | Value |
|---|---|
| Version | Oracle Database 19c |
| Edition | Enterprise Edition |
| Installation Type | Software Only |
| Oracle Base | /u01/app/oracle |
| Oracle Home | /u01/app/oracle/product/19/db_1 |
| Inventory | /u01/app/oraInventory |
| Owner | oracle |
| Group | oinstall |

---

# Step 01 - Validate Oracle Software

Location:

```bash
/u01/software/19c/
```

Validate:

```bash
ls -lh /u01/software/19c/
```

Expected:

```text
LINUX.X64_193000_db_home.zip
```

---

# Step 02 - Response File

Location:

```text
/u01/software/19c/response/db_install_19c.rsp
```

Validate:

```bash
ls -l /u01/software/19c/response
```

Expected:

```text
oracle oinstall db_install_19c.rsp
```

---

# Step 03 - Execute Silent Installation


Run as root:

```bash
/root/scripts/install_19c/02_install_oracle19c_software.sh
```


The script performs:

- ZIP validation
- Oracle Home validation
- Software extraction
- Silent installation execution


Expected result:


```text
Successfully Setup Software.
```

---

# Step 04 - Execute Root Scripts


Run:

```bash
/u01/app/oraInventory/orainstRoot.sh


/u01/app/oracle/product/19/db_1/root.sh
```


Expected:

```text
The execution of the script is complete.
```

---

# Step 05 - Oracle Home Validation


Execute:

```bash
/root/scripts/install_19c/03_validate_19c_home.sh
```


Validations:

- SQLPlus version
- OPatch version
- Oracle Inventory
- Oracle Home permissions


---

# Step 06 - Capture Evidence


Execute:

```bash
/root/scripts/install_19c/04_capture_19c_install_evidence.sh
```


Generated evidence:

```text
final_validation/

├── sqlplus_version.log
├── opatch_version.log
├── opatch_lsinventory.log
├── oracle_home_size.log
└── orainventory.log
```

---

# Validation Results


## SQLPlus


Expected:


```text
SQL*Plus Release 19.0.0.0.0
Version 19.3.0.0.0
```


Status:


```text
PASSED
```


---


## OPatch


Expected:


```text
OPatch Version: 12.2.x

OPatch succeeded.
```


Status:


```text
PASSED
```

---

## Inventory Validation


Expected:


```text
Oracle Database 19c 19.0.0.0.0
Oracle Home:
/u01/app/oracle/product/19/db_1
```


Status:


```text
PASSED
```

---

# Rollback Strategy


Before continuing:

Create VMware Snapshot.


Snapshot Name:


```text
ORACLE19C_SOFTWARE_INSTALLED
```


Description:


```text
Oracle Linux 7.9

Oracle Database 19c Enterprise Edition

Software installation completed

Oracle Home:
/u01/app/oracle/product/19/db_1


Inventory:
/u01/app/oraInventory


Database:
Not created


Ready for:
NEXUS Non-CDB Database Creation
```

---

# GO / NO-GO Checklist


| Check | Status |
|---|---|
| Oracle binaries installed | PASSED |
| runInstaller completed | PASSED |
| root scripts executed | PASSED |
| SQLPlus validated | PASSED |
| OPatch validated | PASSED |
| Inventory validated | PASSED |
| Evidence captured | PASSED |
| Snapshot created | PASSED |


---

# Final Decision


```text
=====================================

PHASE 02 RESULT:

GO

READY FOR:

Phase 03
Oracle 19c NEXUS Non-CDB Creation

=====================================
```
