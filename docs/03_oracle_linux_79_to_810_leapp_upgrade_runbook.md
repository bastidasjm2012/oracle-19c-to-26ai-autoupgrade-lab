# Oracle Linux 7.9 to Oracle Linux 8.10 Upgrade Runbook
## Phase 2 - Operating System Upgrade Using Leapp Utility

Author: Jesus Bastidas  
Role: Enterprise Database Architect / Senior Oracle DBA

---

# 1. Overview

This document describes the procedure to upgrade the operating system layer
required before upgrading:

Oracle Database 19c

to

Oracle AI Database 26ai

The upgrade is executed using Oracle Leapp Utility.

The objective of this phase is ONLY:

Oracle Linux 7.9
→
Oracle Linux 8.10


No database upgrade is performed during this phase.

---

# 2. Upgrade Architecture


## Current State


```text
Server: srvdb-19c


Oracle Linux 7.9

        |
        |
        v


Oracle Database 19c

Database:
NEXUS

Architecture:
NON-CDB


Oracle Home:

/u01/app/oracle/product/19/db_1

```


## Target State


```text

Server: srvdb-19c


Oracle Linux 8.10


        |
        |
        v


Oracle Database 19c


Database:
NEXUS


Architecture:
NON-CDB


Same Oracle Home

/u01/app/oracle/product/19/db_1


```

---

# 3. Pre Upgrade Requirements


Before executing Leapp:


## Database Requirements


|Check|Required|
|-|-|
|RMAN Backup|YES|
|RMAN Validate|YES|
|Database Capture|YES|
|Listener Status Saved|YES|
|Oracle Inventory Backup|YES|



## OS Requirements


|Check|Required|
|-|-|
|root access|YES|
|VM Snapshot|YES|
|Internet Repository Access|YES|
|/boot free space|>100 MB|
|/u01 free space|>10GB|


---

# 4. Snapshot Validation


Before continuing:


```bash
VM Snapshot:

Name:

PRE_OL79_TO_OL810_UPGRADE


Status:

COMPLETED

```


Rollback point:

```text

Oracle Linux 7.9
Oracle Database 19c

```

---

# 5. Execute Leapp Precheck


Login:

```bash
root
```


Run:


```bash
cd scripts/os_upgrade


./01_leapp_precheck.sh

```


Review:


```bash

cat /var/log/leapp/leapp-report.txt


```


Expected:


```text

Risk Factor: NONE

No inhibitors detected

```


---

# 6. Handling Leapp Inhibitors


If inhibitors are detected:


Execute:


```bash

./02_fix_common_inhibitors.sh


```


Common issues:


|Problem|Solution|
|-|-|
|Old kernels|Remove unused kernel-devel|
|PAM pkcs11|Create leapp answer|
|Repositories disabled|Enable OL repos|
|Unsupported packages|Remove/update packages|


Re-run:


```bash

leapp preupgrade

```


---

# 7. Stop Oracle Services


Before OS upgrade:


Login:

```bash
oracle
```


Execute:


```bash

./03_shutdown_oracle_services.sh


```


Validate:


```bash

ps -ef | grep pmon


```


Expected:

```text

No database processes running

```


---

# 8. Execute Oracle Linux Upgrade


Login:


```bash

root

```


Execute:


```bash

./04_execute_leapp_upgrade.sh

```


Or manually:


```bash

leapp upgrade

```


When finished:


```bash

reboot

```


---

# 9. First Boot Validation


After reboot:


Check OS:


```bash

cat /etc/oracle-release

```


Expected:


```text

Oracle Linux Server release 8.10

```



Check kernel:


```bash

uname -r

```


---

# 10. Start Oracle 19c


Login:


```bash

su - oracle

```


Set environment:


```bash

. oraenv

NEXUS

```


Start:


```sql

sqlplus / as sysdba


startup;


```


---

# 11. Post OS Upgrade Validation


Execute:


```bash

./05_post_os_upgrade_validation.sh

```



Validate:


```sql

select name,
       open_mode,
       cdb
from v$database;


select version
from v$instance;

```


Expected:


```text

NEXUS

READ WRITE

NON-CDB

19c

```


---

# 12. Evidence Collection


Save:


```text

evidence/
└── phase02_os_upgrade/


leapp-report.txt

leapp-upgrade.log

oracle_startup.log

post_os_validation.log

```


---

# 13. Rollback Plan


## Scenario 1

Leapp fails before reboot:


Action:


```text

Do not reboot

Fix inhibitors

Retry

```



## Scenario 2

OS does not boot:


Action:


```text

Restore VM Snapshot

```



## Scenario 3

Oracle does not start:


Actions:


- Validate libraries
- Validate environment variables
- Check alert log
- Restore snapshot if required


---

# 14. Completion Criteria


The phase is completed when:


- [x] Oracle Linux 8.10 running

- [x] Oracle 19c starts correctly

- [x] Listener running

- [x] Database OPEN READ WRITE

- [x] No invalid OS dependencies


---

# Phase Status


```text

STATUS:

READY FOR PHASE 3

Oracle 19c Non-CDB
to
Oracle 19c CDB/PDB Conversion

```

