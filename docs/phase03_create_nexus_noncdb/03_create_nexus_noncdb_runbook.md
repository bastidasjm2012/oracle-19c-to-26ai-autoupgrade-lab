# Phase 03 - Create Oracle Database 19c NEXUS Non-CDB

## Project

Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab using AutoUpgrade Utility

---

## Objective

This phase creates the source Oracle Database environment used for the migration and upgrade lifecycle.

The database is intentionally created using the legacy **Non-CDB architecture** to simulate a real enterprise scenario where existing Oracle 11g/12c/19c databases must be modernized before upgrading to Oracle AI Database 26ai.

---

# Architecture Flow


```text
Oracle Linux 7.9
        |
        |
        v
Oracle Database 19c Enterprise Edition
        |
        |
        v
NEXUS Database
        |
        |
        v
NON-CDB Architecture
        |
        |
        v
Convert to CDB/PDB
        |
        |
        v
Oracle AI Database 26ai
```

---

# Environment Information

| Component | Value |
|---|---|
| Hostname | srvdb19c |
| Operating System | Oracle Linux Server 7.9 |
| Oracle Version | Oracle Database 19c EE |
| Oracle Home | /u01/app/oracle/product/19/db_1 |
| Database Name | NEXUS |
| ORACLE_SID | NEXUS |
| Architecture | NON-CDB |
| Compatible | 19.0.0 |
| ArchiveLog | Enabled |
| Force Logging | Enabled |

---

# Database Creation Method

Database created using:

```text
DBCA Silent Mode
```

Script:

```text
scripts/create_database/

01_create_nexus_noncdb_dbca.sh
```

---

# DBCA Execution


Command:

```bash
/u01/scripts/create_database/01_create_nexus_noncdb_dbca.sh
```

Result:

```text
Prepare for db operation

Creating and starting Oracle instance

Completing Database Creation

100% complete


Database creation complete
```

Database:

```text
Global Database Name:
NEXUS


SID:
NEXUS
```

Status:

```text
PASSED
```

---

# Database Validation


Connection:

```bash
sqlplus / as sysdba
```


Validation:

```sql
select
name,
open_mode,
database_role,
cdb
from v$database;
```


Result:

```text
NAME      OPEN_MODE     DATABASE_ROLE    CDB
-------- ------------- ---------------- ---
NEXUS    READ WRITE    PRIMARY          NO
```

Status:

```text
PASSED
```

---

# ArchiveLog Configuration


Database restarted in mount mode:

```sql
shutdown immediate;

startup mount;
```


Enable ArchiveLog:

```sql
alter database archivelog;
```


Open database:

```sql
alter database open;
```


Validation:

```sql
archive log list;
```


Result:

```text
Database log mode:
Archive Mode


Automatic archival:
Enabled
```


Status:

```text
PASSED
```

---

# Force Logging Configuration


Command:

```sql
alter database force logging;
```


Validation:

```sql
select force_logging
from v$database;
```


Result:

```text
FORCE_LOGGING

YES
```


Status:

```text
PASSED
```

---

# Evidence Collection


Script:

```text
scripts/create_database/

04_capture_nexus_evidence.sh
```


Output:

```text
evidence/

phase03_nexus_noncdb/

validation/

database_status.log
```

Captured:

- Database status
- Instance status
- Oracle version
- ArchiveLog mode
- Force Logging status
- Compatible parameter


---

# Evidence Files


```text
phase03_nexus_noncdb/

├── validation/
│
│   └── database_status.log
│
└── snapshot/

    ├── NEXUS_NONCDB_CREATED.png
    └── snapshot_description.txt
```

---

# VMware Snapshot


Snapshot created after successful validation.


Name:

```text
NEXUS_NONCDB_CREATED
```


Description:

```text
Oracle Linux 7.9

Oracle Database 19c Enterprise Edition


Database:

NEXUS


Architecture:

NON-CDB


Status:

READ WRITE


ArchiveLog:

Enabled


Force Logging:

Enabled


Compatible:

19.0.0


Ready for:

Baseline backup and Non-CDB to PDB conversion preparation
```


Rollback:

```text
AVAILABLE
```

---

# Phase Validation Checklist


| Check | Status |
|---|---|
| DBCA Silent completed | PASSED |
| Oracle Instance created | PASSED |
| Database READ WRITE | PASSED |
| NON-CDB Architecture validated | PASSED |
| ArchiveLog enabled | PASSED |
| Force Logging enabled | PASSED |
| Evidence collected | PASSED |
| VMware Snapshot created | PASSED |


---

# GO / NO-GO Decision


```text
=====================================

PHASE 03 RESULT:


GO


READY FOR:

Phase 04 - Workload Creation
Phase 05 - Non-CDB to PDB Conversion


=====================================
```


