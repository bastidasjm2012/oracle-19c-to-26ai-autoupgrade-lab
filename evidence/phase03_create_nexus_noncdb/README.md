# Phase 03 Evidence - Create NEXUS Non-CDB


## Purpose

This folder contains validation evidence collected after creating the Oracle Database 19c source database.


---

## Database Information


```text
Database:

NEXUS


Version:

Oracle Database 19c Enterprise Edition


Architecture:

NON-CDB


Status:

READ WRITE
```


---

## Enabled Features


| Feature | Status |
|---|---|
| ArchiveLog | Enabled |
| Force Logging | Enabled |
| Compatible | 19.0.0 |


---

## Evidence


```text
validation/

database_status.log
```


Includes:


- v$database validation
- v$instance validation
- ArchiveLog status
- Force Logging status
- Compatibility


---

## Rollback Point


VMware Snapshot:


```text
NEXUS_NONCDB_CREATED
```


Rollback available before:

```text
NON-CDB to PDB Conversion
```
