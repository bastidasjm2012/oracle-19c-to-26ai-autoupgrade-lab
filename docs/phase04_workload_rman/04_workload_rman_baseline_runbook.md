# Phase 04 - Application Workload Creation and RMAN Baseline Backup

## Project

Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab using AutoUpgrade Utility

---

# Objective

This phase prepares the Oracle Database 19c source database with a realistic application workload before starting the modernization process.

The goal is to simulate an enterprise database upgrade scenario:

- Existing application schemas
- Database objects
- User data
- PL/SQL code
- Statistics
- Validated database state
- Complete RMAN recovery point


This phase creates the final safe state before:

```text
Oracle 19c NON-CDB

        |
        |

        v

NEXUS conversion to PDB

        |
        |

        v

Oracle AI Database 26ai Upgrade
```

---

# Environment

| Component | Value |
|---|---|
| OS | Oracle Linux Server 7.9 |
| Database | NEXUS |
| Version | Oracle Database 19c EE |
| Release | 19.3.0 |
| Architecture | NON-CDB |
| ArchiveLog | Enabled |
| Force Logging | Enabled |

---

# Phase Architecture


```text
NEXUS NON-CDB

      |

      +-- APP_CORE schema
      |
      |     +-- Tables
      |     +-- Indexes
      |     +-- Sequences
      |     +-- Procedures
      |
      |
      +-- APP_AUDIT schema
      |
      |     +-- Audit Objects
      |
      |
      +-- DBMS_STATS
      |
      |
      +-- RMAN FULL Backup

```

---

# Repository Structure


```text
scripts/

├── workload/
│
│   ├── 01_create_application_schema.sql
│   └── 02_validate_workload.sql
│

└── backup/

    └── 01_rman_baseline_backup.sh



evidence/

└── phase04_workload_rman/

    ├── create_schema.log
    ├── workload_validation.log
    ├── rman_baseline_backup.log
    |
    └── snapshot/

        ├── NEXUS_WORKLOAD_RMAN_BASELINE.png
        └── snapshot_description.txt

```

---

# Step 01 - Create Application Schemas


Script:

```text
scripts/workload/

01_create_application_schema.sql
```


Execution:

```bash
sqlplus / as sysdba

@/u01/scripts/workload/01_create_application_schema.sql
```


Created schemas:


```text
APP_CORE

APP_AUDIT
```


---

# APP_CORE Objects


## Tables


```text
CUSTOMERS

ORDERS
```


## Sequences


```text
SEQ_CUSTOMERS

SEQ_ORDERS
```


## PL/SQL


```text
Procedure:

APP_CORE.ADD_CUSTOMER
```


---

# APP_AUDIT Objects


Objects:


```text
ACTIVITY_LOG

SEQ_LOG
```


---

# Data Generated


## CUSTOMERS


```text
Rows:

10000
```


## ORDERS


```text
Rows:

10000
```


---

# Statistics Collection


Executed:


```sql
exec dbms_stats.gather_schema_stats('APP_CORE');

exec dbms_stats.gather_schema_stats('APP_AUDIT');
```


Result:


```text
Statistics collected successfully
```

---

# Step 02 - Workload Validation


Script:


```text
02_validate_workload.sql
```


Execution:


```bash
sqlplus / as sysdba \
@/u01/scripts/workload/02_validate_workload.sql
```


Validates:


- Object count
- Table rows
- Invalid objects
- Constraints


---

# Validation Result


```text
APP_CORE.CUSTOMERS

10000 rows


APP_CORE.ORDERS

10000 rows


Invalid Objects:

0
```


Status:


```text
PASSED
```


---

# Step 03 - RMAN Baseline Backup


Script:


```text
backup/

01_rman_baseline_backup.sh
```


Execution:


```bash
/u01/scripts/backup/01_rman_baseline_backup.sh
```


Backup includes:


```text
Database Backup

ArchiveLog Backup

Control File Backup

SPFILE Backup
```


Backup Location:


```text
/u01/backup/NEXUS
```


---

# Recovery Strategy


Available recovery methods:


## VMware Rollback


Snapshot:


```text
NEXUS_WORKLOAD_RMAN_BASELINE
```


## RMAN Restore


Available:


```text
DATABASE

ARCHIVELOG

CONTROLFILE

SPFILE
```

---

# Snapshot Information


Snapshot Name:


```text
NEXUS_WORKLOAD_RMAN_BASELINE
```


Created before:


```text
DBMS_PDB.DESCRIBE

NON-CDB to PDB Conversion

Oracle 26ai Upgrade preparation
```


Rollback:


```text
AVAILABLE
```


---

# GO / NO-GO Checklist


| Validation | Status |
|---|---|
| Schemas created | PASSED |
| Tables created | PASSED |
| Indexes created | PASSED |
| Sequences created | PASSED |
| PL/SQL compiled | PASSED |
| Data loaded | PASSED |
| Statistics gathered | PASSED |
| Invalid objects checked | PASSED |
| RMAN backup completed | PASSED |
| Snapshot created | PASSED |

---

# Final Decision


```text
====================================

PHASE 04 RESULT:

GO


READY FOR:


Phase 05

NEXUS NON-CDB to PDB Conversion

====================================
```
