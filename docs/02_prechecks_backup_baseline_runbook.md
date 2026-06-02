# Oracle Database 19c to Oracle AI Database 26ai
# Phase 1 - Pre Upgrade Execution Runbook

Author: Jesus Bastidas  
Role: Enterprise Database Architect / Senior Oracle DBA

---

# 1. Overview

This document describes the execution order before starting:

Oracle Database 19c
to
Oracle AI Database 26ai Upgrade

using AutoUpgrade Utility.

The purpose of this phase is:

- Validate Operating System
- Validate Oracle Environment
- Capture Database Baseline
- Execute RMAN Backup
- Validate Backup Recovery
- Generate upgrade evidence


---

# 2. Environment

## Source Environment

| Component | Value |
|---|---|
| OS | Oracle Linux 7.9 |
| Database | Oracle Database 19c |
| Architecture | Non-CDB |
| Database Name | NEXUS |
| Oracle Home | /u01/app/oracle/product/19/db_1 |


## Target Environment

| Component | Value |
|---|---|
| OS | Oracle Linux 8.10 |
| Database | Oracle AI Database 26ai |
| Architecture | CDB/PDB |


---

# 3. Create Working Directories


Login as oracle:

```bash
su - oracle
```


Create folders:


```bash
mkdir -p /u01/stage/26ai/precheck_reports

mkdir -p /u01/backup/26ai_preupgrade
```


Validate:


```bash
ls -ltr /u01/stage/26ai

ls -ltr /u01/backup
```


Expected:

```text
precheck_reports
26ai_preupgrade
```


---

# 4. Set Oracle 19c Environment


```bash
export ORACLE_SID=NEXUS

export ORACLE_HOME=/u01/app/oracle/product/19/db_1

export PATH=$ORACLE_HOME/bin:$PATH
```


Validate:


```bash
sqlplus -v
```


Expected:


```text
SQL*Plus Release 19.x
```


---

# 5. Execute OS Precheck


Script:

```text
scripts/prechecks/01_os_precheck.sh
```


Grant permission:


```bash
chmod +x scripts/prechecks/*.sh
```


Execute:


```bash
./scripts/prechecks/01_os_precheck.sh
```


Validate output:


```bash
ls -ltr /u01/stage/26ai/precheck_reports
```


Generated:


```text
os_precheck_YYYYMMDD.log
```


---

# 6. Execute Oracle Environment Check


Run:


```bash
./scripts/prechecks/02_oracle_env_check.sh
```


This validates:


- ORACLE_HOME
- Inventory
- Processes
- Listener
- Environment variables


Generated:


```text
oracle_env_check_YYYYMMDD.log
```


---

# 7. Capture Oracle Database 19c Baseline


Connect:


```bash
sqlplus / as sysdba
```


Execute:


```sql
@scripts/prechecks/03_db_preupgrade_capture.sql
```


The report contains:


- Database version
- CDB status
- Registry components
- Invalid objects
- Datafiles
- Redo logs
- Parameters
- Users
- Options


Output:


```text
db_preupgrade_capture_19c.log
```


---

# 8. Listener Validation


Execute:


```bash
./scripts/prechecks/04_listener_check.sh
```


Validate:


```bash
lsnrctl status
```


Expected:


```text
STATUS READY
```


---

# 9. Execute RMAN Full Backup


Validate database:


```bash
sqlplus / as sysdba

select open_mode from v$database;
```


Expected:


```text
READ WRITE
```



Execute Backup:


```bash
rman target / \
cmdfile=scripts/backup/01_rman_full_backup.rcv \
log=/u01/backup/26ai_preupgrade/rman_full_backup.log
```


Backup includes:


✔ Database  
✔ Archivelogs  
✔ Controlfile  
✔ SPFILE  


---

# 10. Validate RMAN Backup


Execute:


```bash
rman target / \
cmdfile=scripts/backup/02_rman_validate_backup.rcv \
log=/u01/backup/26ai_preupgrade/rman_validate_backup.log
```


Expected:


```text
Finished restore validate
```


---

# 11. Backup Summary


Connect RMAN:


```bash
rman target /
```


Execute:


```rman
LIST BACKUP SUMMARY;

REPORT SCHEMA;
```


---

# 12. Final Evidence Collection


Collect:


```bash
/u01/stage/26ai/precheck_reports

/u01/backup/26ai_preupgrade
```


Expected files:


```text
os_precheck.log

oracle_env_check.log

listener_check.log

db_preupgrade_capture_19c.log

rman_full_backup.log

rman_validate_backup.log
```


---

# 13. GO / NO-GO Checklist


|Check|Status|
|-|-|
|OS Validated|✔|
|Oracle Home Validated|✔|
|Listener Running|✔|
|Database OPEN READ WRITE|✔|
|RMAN Backup Completed|✔|
|RMAN Restore Validate OK|✔|
|Invalid Objects Reviewed|✔|
|DB Registry VALID|✔|


If all checks are OK:

Proceed to:

```
Phase 2
Oracle Linux 7.9 → Oracle Linux 8.10 Upgrade
using Leapp Utility
```


---

# End of Phase 1

```
STATUS: READY FOR OS UPGRADE
```
