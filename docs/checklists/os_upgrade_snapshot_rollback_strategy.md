# Oracle Linux Upgrade Snapshot and Rollback Strategy

## Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab

## Phase 2 - Oracle Linux 7.9 to Oracle Linux 8.10

Author: Jesus Bastidas  
Role: Enterprise Database Architect / Senior Oracle DBA


---

# 1. Overview


Before executing Oracle Linux upgrade using Leapp:

Oracle Linux 7.9

to

Oracle Linux 8.10


a rollback point must be created.


This protects:

- Operating System
- Oracle binaries
- Oracle Inventory
- Database files
- Network configuration


Rollback methods depend on the infrastructure platform.


---

# 2. Current Environment


Component | Value
---|---
Server | srvdb-19c
OS | Oracle Linux 7.9
Database | Oracle Database 19c
Database Name | NEXUS
Architecture | Non-CDB
Oracle Home | /u01/app/oracle/product/19/db_1


---

# 3. Oracle Clean Shutdown Before Snapshot


Login as oracle:


```bash
su - oracle
```


Load environment:


```bash
. oraenv

NEXUS
```


Validate database:


```bash
sqlplus / as sysdba
```


Execute:


```sql
select name,
       open_mode
from v$database;
```


Expected:


```text
NAME        OPEN_MODE
---------   ----------------
NEXUS       READ WRITE
```


Exit:


```sql
exit
```


---

# 4. Stop Oracle Listener


Execute:


```bash
lsnrctl stop
```


Validate:


```bash
lsnrctl status
```


Expected:


```text
TNS-12541: no listener
```


---

# 5. Shutdown Oracle Database


Connect:


```bash
sqlplus / as sysdba
```


Shutdown:


```sql
shutdown immediate;

exit;
```


Validate:


```bash
ps -ef | grep pmon
```


Expected:


```text
No PMON processes running
```


Oracle environment is ready for snapshot.


---

# 6. VMware Workstation Snapshot


Recommended for this lab.


Menu:


```text
VM

 |
 +-- Snapshots

        |
        +-- Take Snapshot

```


Snapshot Name:


```text
PRE_OL79_TO_OL810_UPGRADE
```



Description:


```text
Oracle Linux 7.9

Oracle Database:
19c

Database:
NEXUS


Architecture:

NON-CDB


Oracle Home:

/u01/app/oracle/product/19/db_1


Before Leapp upgrade to Oracle Linux 8.10

```


Expected:


```text

Snapshots


Oracle19c-Lab

      |

      +--- PRE_OL79_TO_OL810_UPGRADE

```


---

# 7. VirtualBox Snapshot


Stop Oracle:


```sql
shutdown immediate;
```


Stop Listener:


```bash
lsnrctl stop
```



Menu:


```text

Machine

 |
 +-- Tools

       |
       +-- Snapshots

              |
              +-- Take

```


Snapshot:


```text
PRE_OL79_TO_OL810_UPGRADE
```


---

# 8. OCI Compute Backup Strategy


For OCI environments:


Navigate:


```text

Compute

 |
 +-- Instance

       |
       +-- Boot Volume

              |
              +-- Create Backup

```


Backup name:


```text
PRE_OL79_TO_OL810_UPGRADE
```


If /u01 uses Block Volume:


Create:


```text
Block Volume Backup
```


Required backups:


- Boot Volume
- Block Volume (/u01)


---

# 9. Physical Server Rollback Strategy


Physical servers do not provide snapshots.


Required protection:


## RMAN Backup


Connect:


```bash
rman target /
```


Execute:


```rman

BACKUP DATABASE PLUS ARCHIVELOG;

BACKUP CURRENT CONTROLFILE;

BACKUP SPFILE;

```


---

# 10. Oracle Home Backup


Backup binaries:


```bash
tar -cvzf oracle_home19c.tar.gz \
/u01/app/oracle/product/19/db_1

```


---

# 11. Oracle Configuration Backup


Backup configuration:


```bash
tar -cvzf oracle_config.tar.gz \
/etc/oratab \
/etc/oraInst.loc \
/u01/app/oraInventory

```


---

# 12. Snapshot Validation Record


Complete:


```text

Snapshot Name:

PRE_OL79_TO_OL810_UPGRADE


Status:

COMPLETED


Rollback Point:


OS:

Oracle Linux 7.9


Database:

Oracle Database 19c


DB Name:

NEXUS


Architecture:

NON-CDB


Oracle Home:

/u01/app/oracle/product/19/db_1


```


---

# 13. Evidence Required


Save:


```text
evidence/

└── phase02_os_upgrade/

    ├── snapshot/

    │   ├── snapshot_name.txt

    │   ├── snapshot_screen.png

    │   └── rollback_point.md

    │

    └── before/

        ├── oracle_release_before.txt

        ├── database_status_before.log

        ├── listener_before.log

        └── oracle_process_before.log

```


---

# 14. GO / NO-GO Decision


Continue only if:


|Validation|Status|
|-|-|
|Oracle stopped cleanly|YES|
|RMAN Backup completed|YES|
|Snapshot created|YES|
|Rollback point documented|YES|
|Evidence collected|YES|


Status:


```text

APPROVED FOR LEAPP UPGRADE

```
