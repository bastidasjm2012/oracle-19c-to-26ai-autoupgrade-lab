# Phase 05 - Oracle 19c Non-CDB to PDB Conversion

## Project

Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab using AutoUpgrade Utility.

---

# Objective

Convert the legacy Oracle Database 19c Non-CDB architecture into the required Multitenant architecture before upgrading to Oracle AI Database 26ai.

Oracle Database 26ai requires the Multitenant architecture, therefore existing Non-CDB databases must be converted into Pluggable Databases.

---

# Architecture Overview


## Before Conversion


```text
Oracle Database 19c

NEXUS

Architecture:

NON-CDB


Application:

APP_CORE

APP_AUDIT
```


## After Conversion


```text
Oracle Database 19c

NEXUSCDB
     |
     |
     +--- PDB NEXUS
              |
              |
              +--- APP_CORE
              |
              +--- APP_AUDIT
```

---

# Conversion Method


The migration uses the Oracle supported method:


```text
DBMS_PDB.DESCRIBE

CREATE PLUGGABLE DATABASE

noncdb_to_pdb.sql
```


---

# Environment Information


| Component | Value |
|---|---|
| Source Database | NEXUS |
| Source Architecture | Non-CDB |
| Target CDB | NEXUSCDB |
| Target PDB | NEXUS |
| Oracle Version | 19.3 |
| Upgrade Target | Oracle AI Database 26ai |


---

# Phase Workflow


```text
NEXUS Non-CDB

        |
        |
        v

Precheck Validation


        |
        |
        v


DBMS_PDB.DESCRIBE


        |
        |
        v


NEXUS.xml


        |
        |
        v


CREATE PLUGGABLE DATABASE


        |
        |
        v


Run noncdb_to_pdb.sql


        |
        |
        v


NEXUS PDB Ready
```

---

# Step 01 - Non-CDB Precheck


Script:


```text
scripts/noncdb_to_pdb/

01_noncdb_precheck.sql
```


Validates:


- Database status
- Non-CDB architecture
- Application objects
- Invalid objects
- ArchiveLog status


Expected:


```text
Database:

NEXUS


CDB:

NO


Invalid Objects:

0
```

---

# Step 02 - Generate XML Manifest


Script:


```text
02_create_nexus_xml.sql
```


The database is opened READ ONLY:


```sql
startup open read only;
```


Generate XML:


```sql
BEGIN

DBMS_PDB.DESCRIBE
(
pdb_descr_file =>
'/u01/stage/phase05_noncdb_to_pdb/NEXUS.xml'
);

END;
/
```


Output:


```text
NEXUS.xml
```

---

# Step 03 - Create Target CDB


Script:


```text
03_create_nexuscdb.sh
```


Creates:


```text
CDB:

NEXUSCDB
```


Using:


```text
DBCA Silent Mode
```

---

# Step 04 - Plug Compatibility Check


Script:


```text
04_check_plug_compatibility.sql
```


Uses:


```sql
DBMS_PDB.CHECK_PLUG_COMPATIBILITY
```


Expected:


```text
RESULT:

COMPATIBLE
```

---

# Step 05 - Create PDB NEXUS


Script:


```text
05_plug_nexus_as_pdb.sql
```


Command:


```sql
CREATE PLUGGABLE DATABASE NEXUS

USING 'NEXUS.xml'

COPY;
```


Initial state:


```text
OPEN RESTRICTED
```

---

# Step 06 - Convert Dictionary


Script:


```text
06_run_noncdb_to_pdb.sql
```


Runs:


```sql
$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql
```


Purpose:


- Remove Non-CDB metadata
- Convert dictionary
- Enable Multitenant compatibility


---

# Step 07 - Final Validation


Script:


```text
07_validate_nexus_pdb.sql
```


Expected result:


```text
CDB:

NEXUSCDB


PDB:

NEXUS


OPEN MODE:

READ WRITE


APP_CORE.CUSTOMERS:

10000 rows


APP_CORE.ORDERS:

10000 rows


Invalid Objects:

0
```

---

# Evidence Generated


```text
phase05_noncdb_to_pdb/

├── 01_noncdb_precheck.log
├── 02_create_nexus_xml.log
├── 03_create_nexuscdb.log
├── 04_check_plug_compatibility.log
├── 05_plug_nexus_as_pdb.log
├── 06_run_noncdb_to_pdb.log
└── 07_validate_nexus_pdb.log
```

---

# Rollback Strategy


Available rollback points:


## VMware Snapshot Before Conversion


```text
NEXUS_WORKLOAD_RMAN_BASELINE
```


## RMAN Backup


Includes:


```text
Database

ArchiveLogs

Controlfile

SPFILE
```

---

# VMware Snapshot After Conversion


Name:


```text
NEXUS_CONVERTED_TO_PDB
```


Contains:


```text
Oracle 19c

CDB:
NEXUSCDB


PDB:
NEXUS


Application:

APP_CORE

APP_AUDIT
```

---

# GO / NO-GO Checklist


| Validation | Status |
|---|---|
| XML generated | PASSED |
| CDB created | PASSED |
| Compatibility checked | PASSED |
| PDB created | PASSED |
| noncdb_to_pdb.sql completed | PASSED |
| Application data validated | PASSED |
| Snapshot created | PASSED |


---

# Final Decision


```text
=====================================

PHASE 05 RESULT:

GO


READY FOR:

Phase 06

PDB Health Check & Upgrade Readiness


=====================================
```
