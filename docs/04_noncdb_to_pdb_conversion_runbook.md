# Oracle 19c Non-CDB to CDB/PDB Conversion Runbook
## Phase 3 - DBMS_PDB Migration Method

Author: Jesus Bastidas  
Role: Enterprise Database Architect / Senior Oracle DBA

---

# 1. Overview

This document describes the procedure to migrate an Oracle Database
19c Non-CDB architecture into Oracle Multitenant CDB/PDB architecture.

This step is mandatory before upgrading:

Oracle Database 19c

to

Oracle AI Database 26ai


Starting with Oracle AI Database 26ai:

Non-CDB architecture is not supported.

Therefore:

The existing database:

```
NEXUS
Oracle Database 19c
NON-CDB
```

will become:

```
NEXUSCDB
 |
 +-- NEXUS PDB
```

using:

```
DBMS_PDB.DESCRIBE
CREATE PLUGGABLE DATABASE
noncdb_to_pdb.sql
```

---

# 2. Migration Architecture


## Before Conversion


```
Oracle Linux 8.10


Oracle Database 19c


      Instance

        |

        v


      NEXUS

    NON-CDB


/u01/app/oracle/product/19/db_1

```



## After Conversion


```
Oracle Linux 8.10


Oracle Database 19c


          NEXUSCDB

              |

    ---------------------

    |                   |

 PDB$SEED            NEXUS

                     PDB



/u01/app/oracle/product/19/db_1

```

---

# 3. Conversion Strategy


Migration method:

```
DBMS_PDB
```

Migration type:

```
Plug-in Non-CDB as PDB
```

Downtime:

Required

Data movement:

COPY mode


Rollback:

Original Non-CDB preserved


---

# 4. Pre-Requisites


Required before starting:


|Check|Required|
|-|-|
|Oracle Linux upgraded to 8.10|YES|
|Oracle Database version 19c|YES|
|RMAN backup completed|YES|
|Snapshot available|YES|
|NEXUS open READ WRITE|YES|
|Invalid objects reviewed|YES|


---

# 5. Directory Preparation


Create working directory:


```bash
mkdir -p /u01/stage/26ai/noncdb_to_pdb
```


Validate:


```bash
ls -ltr /u01/stage/26ai
```


---

# 6. Source Database Validation


Set environment:


```bash
export ORACLE_SID=NEXUS

export ORACLE_HOME=/u01/app/oracle/product/19/db_1

export PATH=$ORACLE_HOME/bin:$PATH
```


Execute:


```bash
sqlplus / as sysdba \
@scripts/noncdb_to_pdb/01_source_noncdb_precheck.sql
```


Expected:


```text
DATABASE: NEXUS

OPEN_MODE:

READ WRITE


CDB:

NO

```


---

# 7. Generate XML Manifest File


Execute:


```bash
sqlplus / as sysdba \
@scripts/noncdb_to_pdb/02_create_manifest_xml.sql
```



This performs:


```
shutdown immediate

startup open read only

DBMS_PDB.DESCRIBE

```


Generated:


```
/u01/stage/26ai/noncdb_to_pdb/NEXUS.xml
```


Validate:


```bash
ls -lh /u01/stage/26ai/noncdb_to_pdb/NEXUS.xml
```


---

# 8. Create Target CDB


Create:

```
NEXUSCDB
```


Using:


```bash
scripts/noncdb_to_pdb/create_nexuscdb_dbca_silent.sh
```



Expected:


```sql
select name,cdb
from v$database;


NAME        CDB
---------   ----

NEXUSCDB    YES

```


---

# 9. Validate Target CDB


Set environment:


```bash
export ORACLE_SID=NEXUSCDB
```


Execute:


```bash
sqlplus / as sysdba \
@scripts/noncdb_to_pdb/03_target_cdb_precheck.sql
```



Validate:


```text
CDB$ROOT

PDB$SEED

OPEN

```


---

# 10. Check Plug Compatibility


Execute:


```bash
sqlplus / as sysdba \
@scripts/noncdb_to_pdb/04_check_plug_compatibility.sql
```



Expected:


```text
RESULT:

COMPATIBLE

```


Check:


```sql
select *
from pdb_plug_in_violations;

```


Allowed:

```
WARNING
```

Not allowed:


```
ERROR

PENDING

```


---

# 11. Plug NEXUS as PDB


Execute:


```bash
sqlplus / as sysdba \
@scripts/noncdb_to_pdb/05_plug_noncdb_as_pdb.sql
```


Expected:


```text

CON_NAME

NEXUS


OPEN_MODE

MOUNTED

```


---

# 12. Execute noncdb_to_pdb.sql


Execute:


```bash
sqlplus / as sysdba \
@scripts/noncdb_to_pdb/06_run_noncdb_to_pdb.sql
```


This converts:


Dictionary metadata

Users

Objects

Privileges

Components


Expected:


```text

NEXUS

READ WRITE

```


---

# 13. Post Conversion Validation


Execute:


```bash
sqlplus / as sysdba \
@scripts/noncdb_to_pdb/07_post_conversion_validation.sql
```



Validate:


## PDB Status


```sql
show pdbs

```


Expected:


```
NEXUS READ WRITE

```


## Registry


```sql
select status
from dba_registry;

```


Expected:


```
VALID

```



## Invalid Objects


Expected:


```
0

```


---

# 14. Save PDB State


Execute:


```bash
sqlplus / as sysdba \
@scripts/noncdb_to_pdb/08_save_pdb_state.sql
```



Validate:


```sql
select *
from dba_pdb_saved_states;

```


Expected:


```
NEXUS

OPEN

```


---

# 15. Evidence Collection


Store:


```
evidence/

└── phase03_noncdb_to_pdb/

    |
    ├── before/

    │   ├── nexus_database_status.log

    │   ├── registry_before.log

    │   └── invalid_objects_before.log

    |

    ├── conversion/

    │   ├── NEXUS.xml

    │   ├── plug_compatibility.log

    │   └── noncdb_to_pdb_execution.log

    |

    └── after/

        ├── pdb_status.log

        ├── registry_after.log

        └── invalid_objects_after.log

```


---

# 16. Rollback Strategy


## Before noncdb_to_pdb.sql


Action:


Drop plugged PDB:


```sql
drop pluggable database NEXUS
including datafiles;

```


Original:


```
NEXUS Non-CDB

still available

```



---

## After Conversion Failure


Options:


1. Restore VM Snapshot


or


2. RMAN Restore


```bash
rman target /

restore database;

recover database;

```


---

# 17. GO / NO-GO Checklist


Continue to Oracle 26ai installation only if:


|Validation|Status|
|-|-|
|NEXUSCDB created|YES|
|NEXUS PDB READ WRITE|YES|
|PDB violations resolved|YES|
|Registry VALID|YES|
|Invalid objects reviewed|YES|
|Application objects validated|YES|
|Backup available|YES|


---

# Phase Completion


Status:


```
READY FOR PHASE 4

Install Oracle AI Database 26ai Home

```

