# Phase 04 Evidence - Application Workload and RMAN Baseline

## Project

Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab using AutoUpgrade Utility.

---

## Purpose

This folder contains the evidence generated during Phase 04 of the lab.

The purpose of this phase is to prepare the Oracle 19c source database with a realistic workload before executing the Non-CDB to PDB conversion and later the Oracle AI Database 26ai upgrade.

This phase validates that the source database is not empty and contains application schemas, database objects, user data, statistics, and a recoverable RMAN baseline.

---

# Source Database

| Component | Value |
|---|---|
| Database | NEXUS |
| Version | Oracle Database 19c Enterprise Edition |
| Release | 19.3.0 |
| Architecture | NON-CDB |
| Open Mode | READ WRITE |
| ArchiveLog | Enabled |
| Force Logging | Enabled |
| Compatible | 19.0.0 |

---

# Application Schemas

The following application schemas were created:

```text
APP_CORE
APP_AUDIT
```

---

# Application Objects

## APP_CORE

### Tables

```text
CUSTOMERS
ORDERS
```

### Indexes

```text
Primary key indexes
Foreign key related indexes
```

### Sequences

```text
SEQ_CUSTOMERS
SEQ_ORDERS
```

### PL/SQL Objects

```text
Procedure:

APP_CORE.ADD_CUSTOMER
```

---

## APP_AUDIT

### Tables

```text
ACTIVITY_LOG
```

### Sequences

```text
SEQ_LOG
```

---

# Data Volume

| Object | Rows |
|---|---:|
| APP_CORE.CUSTOMERS | 10000 |
| APP_CORE.ORDERS | 10000 |
| APP_AUDIT.ACTIVITY_LOG | 0 |

---

# Statistics Collection

Statistics were collected using:

```sql
EXEC DBMS_STATS.GATHER_SCHEMA_STATS('APP_CORE');

EXEC DBMS_STATS.GATHER_SCHEMA_STATS('APP_AUDIT');
```

Result:

```text
Statistics collected successfully
```

---

# Evidence Directory Structure

```text
phase04_workload_rman/

├── README.md
├── create_schema.log
├── workload_validation.log
├── rman_baseline_backup.log
│
└── snapshot/

    ├── NEXUS_WORKLOAD_RMAN_BASELINE.png
    └── snapshot_description.txt
```

---

# Evidence File Description


| File | Description |
|---|---|
| create_schema.log | Schema creation, objects, data loading and statistics execution |
| workload_validation.log | Objects, constraints, rows and invalid object validation |
| rman_baseline_backup.log | RMAN backup execution output |
| NEXUS_WORKLOAD_RMAN_BASELINE.png | VMware rollback snapshot evidence |
| snapshot_description.txt | Snapshot metadata information |

---

# Workload Validation Summary


## Row Count Validation


```text
APP_CORE.CUSTOMERS

Rows:
10000


APP_CORE.ORDERS

Rows:
10000
```


## Invalid Objects


```text
Invalid Objects:

0
```


Status:

```text
PASSED
```

---

# RMAN Baseline Backup


## Backup Strategy


A complete RMAN backup was executed before starting the database architecture conversion.


The backup includes:


```text
FULL DATABASE BACKUP

ARCHIVELOG BACKUP

CURRENT CONTROLFILE BACKUP

SPFILE BACKUP
```


Backup location:


```text
/u01/backup/NEXUS
```


Purpose:


```text
Provide database recovery capability before:

- DBMS_PDB.DESCRIBE
- Non-CDB to PDB conversion
- Oracle AI Database 26ai Upgrade preparation
```

---

# Recovery Strategy


Two rollback mechanisms are available.


---

## Option 1 - VMware Snapshot


Snapshot Name:


```text
NEXUS_WORKLOAD_RMAN_BASELINE
```


Purpose:


```text
Full VM rollback point before database architecture conversion.
```


Rollback Status:


```text
AVAILABLE
```

---

## Option 2 - RMAN Restore


Available backups:


```text
Database

ArchiveLogs

Control File

SPFILE
```


Purpose:


```text
Database-level recovery if restore is required.
```

---

# VMware Snapshot Information


Snapshot:

```text
NEXUS_WORKLOAD_RMAN_BASELINE
```


Description:


```text
Oracle Linux 7.9


Oracle Database:

19c Enterprise Edition


Database:

NEXUS


Architecture:

NON-CDB


Status:

READ WRITE


Recovery:

ARCHIVELOG Enabled

FORCE LOGGING Enabled


Schemas:

APP_CORE

APP_AUDIT


Application Objects:

Tables

Indexes

Sequences

PL/SQL Procedures


Data:

APP_CORE.CUSTOMERS:
10000 rows


APP_CORE.ORDERS:
10000 rows


Statistics:

DBMS_STATS completed


RMAN:

Baseline backup completed


Ready For:

Non-CDB to PDB Conversion
```

---

# Phase 04 Validation Checklist


| Validation | Status |
|---|---|
| APP_CORE schema created | PASSED |
| APP_AUDIT schema created | PASSED |
| Tables created | PASSED |
| Indexes created | PASSED |
| Sequences created | PASSED |
| PL/SQL compiled | PASSED |
| Data generated | PASSED |
| Statistics gathered | PASSED |
| Invalid objects validation | PASSED |
| RMAN database backup | PASSED |
| RMAN archivelog backup | PASSED |
| Control file backup | PASSED |
| SPFILE backup | PASSED |
| VMware snapshot created | PASSED |

---

# Final GO / NO-GO Decision


```text
====================================

PHASE 04 RESULT:

GO


DATABASE STATE:

Oracle 19c NON-CDB with workload


RECOVERY:

RMAN Baseline Available

VM Snapshot Available


READY FOR:


Phase 05

NEXUS Non-CDB to PDB Conversion


====================================
```

---

# Current Upgrade Journey Status


```text
Oracle Database 19c to Oracle AI Database 26ai Upgrade


[✓] Phase 00

Oracle Linux 7.9 Build


[✓] Phase 01

Oracle 19c Prerequisites


[✓] Phase 02

Oracle 19c Software Installation


[✓] Phase 03

NEXUS Non-CDB Creation


[✓] Phase 04

Application Workload + RMAN Baseline


[NEXT]

Phase 05

Non-CDB to PDB Conversion
```


