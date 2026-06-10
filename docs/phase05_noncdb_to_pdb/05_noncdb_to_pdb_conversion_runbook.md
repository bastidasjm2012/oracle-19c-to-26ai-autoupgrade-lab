# Phase 05 - Oracle 19c Non-CDB to PDB Conversion

## Project

Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab using AutoUpgrade Utility.

---

## Objective

Convert the legacy Oracle Database 19c Non-CDB architecture into Oracle Multitenant architecture.

Oracle AI Database 26ai only supports the Multitenant architecture, therefore the legacy Non-CDB database must be converted into a Pluggable Database (PDB) before executing AutoUpgrade.

---

# Architecture Overview

## Before Conversion

```text
Oracle Database 19c Enterprise Edition

Database:
NEXUS

Architecture:
NON-CDB

Application Schemas:

APP_CORE
APP_AUDIT
```

---

## After Conversion

```text
Oracle Database 19c Enterprise Edition

Container Database:

NEXUSCDB


        NEXUSCDB
            |
            |
            +---- NEXUS PDB
                     |
                     |
                     +---- APP_CORE
                     |
                     +---- APP_AUDIT
```

---

# Conversion Strategy

The conversion follows the Oracle recommended approach:

```text
1. Validate Non-CDB source

2. Generate XML metadata file

       DBMS_PDB.DESCRIBE

3. Create destination CDB

       DBCA Silent

4. Check plug compatibility

       DBMS_PDB.CHECK_PLUG_COMPATIBILITY

5. Plug database as PDB

       CREATE PLUGGABLE DATABASE

6. Convert dictionary

       noncdb_to_pdb.sql

7. Validate application

8. Save PDB State
```

---

# Environment

| Component | Value |
|---|---|
| Source Database | NEXUS |
| Source Type | Non-CDB |
| Target CDB | NEXUSCDB |
| Target PDB | NEXUS |
| Oracle Version | 19.3 |
| OS | Oracle Linux 7.9 |
| Upgrade Target | Oracle AI Database 26ai |

---

# Repository Structure

```text
scripts/

└── noncdb_to_pdb/

    ├── 01_noncdb_precheck.sql
    ├── 02_create_nexus_xml.sql
    ├── 03_create_nexuscdb.sh
    ├── 04_check_plug_compatibility.sql
    ├── 05_plug_nexus_as_pdb.sql
    ├── 06_run_noncdb_to_pdb.sql
    ├── 07_validate_nexus_pdb.sql
    └── 08_save_pdb_state.sql
```

---

# Step 01 - Non-CDB Precheck

## Script

```text
01_noncdb_precheck.sql
```

Validations:

- Database status
- Open mode
- Database role
- CDB flag
- Application schemas
- Invalid objects
- ArchiveLog status


Expected:

```text
Database:

NEXUS

CDB:

NO

OPEN MODE:

READ WRITE

Invalid Objects:

0
```

Evidence:

```text
01_noncdb_precheck.log
```

---

# Step 02 - Generate XML Manifest

## Script

```text
02_create_nexus_xml.sql
```

Database is started:

```sql
startup open read only;
```

Generate metadata:

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

Generated file:

```text
/u01/stage/phase05_noncdb_to_pdb/NEXUS.xml
```

Evidence:

```text
02_create_nexus_xml.log
```

---

# Step 03 - Create Target CDB

## Script

```text
03_create_nexuscdb.sh
```


Creates:

```text
Container Database:

NEXUSCDB
```


Using:

```text
DBCA Silent Mode
```

Parameters:

```text
createAsContainerDatabase=true

numberOfPDBs=0
```

Evidence:

```text
03_create_nexuscdb.log
```

---

# Step 04 - Check Plug Compatibility

## Script

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

Review:

```sql
select *
from pdb_plug_in_violations;
```

Evidence:

```text
04_check_plug_compatibility.log
```

---

# Step 05 - Plug NEXUS as PDB

## Script

```text
05_plug_nexus_as_pdb.sql
```


Creates:

```sql
CREATE PLUGGABLE DATABASE NEXUS
USING 'NEXUS.xml'
COPY;
```


Initial status:

```text
NEXUS

OPEN RESTRICTED
```

Evidence:

```text
05_plug_nexus_as_pdb.log
```

---

# Step 06 - Execute noncdb_to_pdb.sql

## Script

```text
06_run_noncdb_to_pdb.sql
```


Connect:

```sql
alter session set container=NEXUS;
```


Execute:

```sql
@$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql
```


This performs:

- Dictionary conversion
- Metadata cleanup
- Component validation
- Multitenant enablement


Expected:

```text
NEXUS

READ WRITE
```

Evidence:

```text
06_run_noncdb_to_pdb.log
```

---

# Step 07 - Validate Converted PDB

## Script

```text
07_validate_nexus_pdb.sql
```

Validates:

- PDB status
- Application schemas
- Object count
- Invalid objects
- Application data


Expected:

```text
CDB:

NEXUSCDB


PDB:

NEXUS


OPEN MODE:

READ WRITE


APP_CORE.CUSTOMERS:

10000


APP_CORE.ORDERS:

10000


INVALID OBJECTS:

0
```

Evidence:

```text
07_validate_nexus_pdb.log
```

---

# Step 08 - Save PDB State

## Script

```text
08_save_pdb_state.sql
```


Purpose:

Configure automatic PDB opening after CDB restart.

Without this configuration, after restarting the CDB the PDB remains mounted.


Execute:

```sql
alter pluggable database NEXUS save state;
```


Validate:

```sql
select
 con_name,
 state
from dba_pdb_saved_states;
```


Expected:

```text
CON_NAME     STATE
------------ --------

NEXUS        OPEN
```


Evidence:

```text
08_save_pdb_state.log
```

---

# Evidence Structure


```text
evidence/

└── phase05_noncdb_to_pdb/

    ├── README.md
    |
    ├── 01_noncdb_precheck.log
    ├── 02_create_nexus_xml.log
    ├── 03_create_nexuscdb.log
    ├── 04_check_plug_compatibility.log
    ├── 05_plug_nexus_as_pdb.log
    ├── 06_run_noncdb_to_pdb.log
    ├── 07_validate_nexus_pdb.log
    └── 08_save_pdb_state.log

```

---

# Rollback Strategy

Available rollback points:

## VMware Snapshot

Before conversion:

```text
NEXUS_WORKLOAD_RMAN_BASELINE
```


After successful conversion:

```text
NEXUS_CONVERTED_TO_PDB
```


---

# Final Architecture


```text
Oracle Database 19c


NEXUSCDB

   |
   |
   +---- NEXUS PDB

          |
          |

          APP_CORE

          APP_AUDIT



Status:

READ WRITE


Save State:

ENABLED


Ready:

AutoUpgrade
Oracle Database AI 26ai

```

---

# Validation Checklist


| Validation | Status |
|---|---|
| Non-CDB validated | PASSED |
| XML generated | PASSED |
| CDB created | PASSED |
| Plug compatibility checked | PASSED |
| PDB created | PASSED |
| noncdb_to_pdb.sql completed | PASSED |
| Application schemas validated | PASSED |
| Application data validated | PASSED |
| PDB save state configured | PASSED |
| VMware snapshot created | PASSED |

---

# GO / NO-GO Decision


```text
====================================

PHASE 05 RESULT:

GO


READY FOR:

Phase 06

PDB Health Check & Upgrade Readiness

====================================
```
