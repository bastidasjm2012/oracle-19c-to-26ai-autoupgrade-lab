# Oracle Database 19c CDB/PDB to Oracle AI Database 26ai AutoUpgrade Runbook

## Phase 5 - AutoUpgrade Execution

Author: Jesus Bastidas
Role: Enterprise Database Architect / Senior Oracle DBA

---

# 1. Overview

This document describes the execution procedure to upgrade:

```text
Oracle Database 19c CDB/PDB
```

to:

```text
Oracle AI Database 26ai
```

using:

```text
Oracle AutoUpgrade Utility
```

This phase upgrades the already converted 19c CDB/PDB environment:

```text
CDB: NEXUSCDB
PDB: NEXUS
```

to Oracle AI Database 26ai.

---

# 2. Architecture Before Upgrade

```text
Oracle Linux 8.10

Oracle Database 19c

/u01/app/oracle/product/19/db_1

        NEXUSCDB
            |
            +-- PDB$SEED
            |
            +-- NEXUS
```

---

# 3. Architecture After Upgrade

```text
Oracle Linux 8.10

Oracle AI Database 26ai

/u01/app/oracle/product/26ai/dbhome_1

        NEXUSCDB
            |
            +-- PDB$SEED
            |
            +-- NEXUS
```

---

# 4. Pre-Requisites

| Check                                   | Required |
| --------------------------------------- | -------- |
| Oracle Linux 8.10 validated             | YES      |
| Oracle 19c CDB/PDB conversion completed | YES      |
| Oracle 26ai Home installed              | YES      |
| AutoUpgrade jar available               | YES      |
| RMAN backup completed                   | YES      |
| VM snapshot available                   | YES      |
| NEXUSCDB open READ WRITE                | YES      |
| NEXUS PDB open READ WRITE               | YES      |
| Registry components VALID               | YES      |

---

# 5. Directory Structure

```bash
mkdir -p /u01/app/oracle/autoupgrade
mkdir -p /u01/app/oracle/autoupgrade/upgrade_logs
mkdir -p /u01/app/oracle/cfgtoollogs/upgrade
mkdir -p /u01/stage/26ai/autoupgrade
```

---

# 6. AutoUpgrade Configuration File

File:

```text
config/autoupgrade/autoupg.cfg
```

Content:

```properties
global.global_log_dir=/u01/app/oracle/cfgtoollogs/upgrade

upg1.sid=NEXUSCDB
upg1.source_home=/u01/app/oracle/product/19/db_1
upg1.target_home=/u01/app/oracle/product/26ai/dbhome_1
upg1.restoration=YES
upg1.log_dir=/u01/app/oracle/autoupgrade/upgrade_logs
upg1.timezone_upg=YES
```

Copy to server:

```bash
cp config/autoupgrade/autoupg.cfg /u01/app/oracle/autoupgrade/autoupg.cfg
```

---

# 7. Prepare AutoUpgrade Utility

Execute:

```bash
./scripts/autoupgrade/01_prepare_autoupgrade.sh
```

Manual commands:

```bash
cp /u01/stage/26ai/autoupgrade.jar /u01/app/oracle/autoupgrade/

chmod 755 /u01/app/oracle/autoupgrade/autoupgrade.jar

/u01/app/oracle/product/26ai/dbhome_1/jdk/bin/java \
-jar /u01/app/oracle/autoupgrade/autoupgrade.jar \
-version
```

Expected:

```text
AutoUpgrade version displayed successfully.
Supported target versions include 26.
```

---

# 8. Capture Pre-Upgrade Baseline

Set 19c environment:

```bash
export ORACLE_SID=NEXUSCDB
export ORACLE_HOME=/u01/app/oracle/product/19/db_1
export PATH=$ORACLE_HOME/bin:$PATH
```

Execute:

```bash
sqlplus / as sysdba @scripts/autoupgrade/02_capture_before_upgrade.sql
```

Generated file:

```text
/u01/stage/26ai/DB_capture_pre_19c.txt
```

---

# 9. Run AutoUpgrade Analyze Mode

Analyze mode validates the database without making changes.

Set 26ai environment:

```bash
export ORACLE_HOME=/u01/app/oracle/product/26ai/dbhome_1
export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/bin:$PATH
```

Execute:

```bash
./scripts/autoupgrade/03_run_analyze.sh
```

Manual command:

```bash
java -jar /u01/app/oracle/autoupgrade/autoupgrade.jar \
-config /u01/app/oracle/autoupgrade/autoupg.cfg \
-mode analyze
```

Useful AutoUpgrade console commands:

```text
lsj
status
status -job <JOB_ID>
tasks
```

Expected result:

```text
PRECHECKS: SUCCESS
Manual intervention: NONE
```

Evidence:

```text
evidence/phase05_autoupgrade/analyze/
```

---

# 10. Run AutoUpgrade Fixups Mode

Fixups mode applies required pre-upgrade corrections.

Execute:

```bash
./scripts/autoupgrade/04_run_fixups.sh
```

Manual command:

```bash
java -jar /u01/app/oracle/autoupgrade/autoupgrade.jar \
-config /u01/app/oracle/autoupgrade/autoupg.cfg \
-mode fixups
```

Expected result:

```text
PRECHECKS: SUCCESS
PREFIXUPS: SUCCESS
```

Evidence:

```text
evidence/phase05_autoupgrade/fixups/
```

---

# 11. Run AutoUpgrade Deploy Mode

WARNING:

Deploy mode performs the real database upgrade.

The database will be unavailable during this phase.

Execute:

```bash
./scripts/autoupgrade/05_run_deploy.sh
```

Manual command:

```bash
java -jar /u01/app/oracle/autoupgrade/autoupgrade.jar \
-config /u01/app/oracle/autoupgrade/autoupg.cfg \
-mode deploy
```

Expected stages:

```text
SETUP
GRP
PREUPGRADE
PRECHECKS
PREFIXUPS
DRAIN
DBUPGRADE
POSTCHECKS
POSTFIXUPS
POSTUPGRADE
SYSUPDATES
```

Expected final result:

```text
Jobs finished: 1
Jobs failed: 0
```

---

# 12. Guaranteed Restore Point

Because the configuration uses:

```properties
upg1.restoration=YES
```

AutoUpgrade creates a Guaranteed Restore Point.

Validate after deploy:

```sql
select name,
       time
from v$restore_point;
```

Do not drop the restore point until the upgrade has been fully validated.

---

# 13. Monitor AutoUpgrade

Inside AutoUpgrade console:

```text
status
status -job <JOB_ID>
lsj
tasks
```

From OS:

```bash
./scripts/autoupgrade/06_monitor_autoupgrade.sh
```

Important log locations:

```text
/u01/app/oracle/cfgtoollogs/upgrade
/u01/app/oracle/autoupgrade/upgrade_logs/NEXUSCDB
```

---

# 14. Post-Upgrade Validation

Set 26ai environment:

```bash
export ORACLE_SID=NEXUSCDB
export ORACLE_HOME=/u01/app/oracle/product/26ai/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
```

Execute:

```bash
sqlplus / as sysdba @scripts/autoupgrade/07_post_upgrade_validation.sql
```

Expected:

```text
Oracle AI Database 26ai
NEXUSCDB READ WRITE
CDB YES
NEXUS PDB READ WRITE
Registry components VALID
```

Generated file:

```text
/u01/stage/26ai/DB_capture_post_26ai.txt
```

---

# 15. Compare Pre and Post Upgrade

Execute:

```bash
./scripts/autoupgrade/08_compare_pre_post.sh
```

Generated file:

```text
/u01/stage/26ai/pre_post_comparison.txt
```

Review differences:

```bash
less /u01/stage/26ai/pre_post_comparison.txt
```

Expected differences:

```text
Database version changed from 19c to 26ai
Oracle Home changed from 19c to 26ai
Timezone file may be upgraded
CDB/PDB status remains valid
```

---

# 16. Listener Validation

Validate listener:

```bash
lsnrctl status
```

Expected:

```text
NEXUSCDB service READY
NEXUS PDB service READY
```

---

# 17. Drop Restore Point

Only after functional validation.

Review:

```sql
select name,
       time
from v$restore_point;
```

Drop manually:

```sql
drop restore point AUTOUPGRADE_xxxxx;
```

Reference script:

```bash
sqlplus / as sysdba @scripts/autoupgrade/09_drop_restore_point.sql
```

---

# 18. Rollback Strategy

## Analyze Fails

No database changes are made.

Action:

```text
Review preupgrade log.
Fix issues.
Run analyze again.
```

## Fixups Fails

Usually no destructive changes.

Action:

```text
Review prefixups logs.
Fix issues manually.
Run fixups again.
```

## Deploy Fails

Use AutoUpgrade restore.

Inside console:

```text
restore -job <JOB_ID>
```

or:

```text
restore all_failed
```

## After Upgrade Validation Fails

If GRP still exists:

```text
Use AutoUpgrade restore or flashback strategy.
```

If GRP was dropped:

```text
RMAN restore required.
```

---

# 19. Evidence Collection

Recommended GitHub evidence structure:

```text
evidence/
└── phase05_autoupgrade/
    ├── before/
    │   └── DB_capture_pre_19c.txt
    ├── analyze/
    │   ├── status.log
    │   └── preupgrade.log
    ├── fixups/
    │   ├── status.log
    │   └── prefixups.html
    ├── deploy/
    │   ├── status.log
    │   ├── status.html
    │   └── upg_summary.log
    ├── after/
    │   └── DB_capture_post_26ai.txt
    └── reports/
        └── pre_post_comparison.txt
```

---

# 20. GO / NO-GO Checklist

Continue only if:

| Validation                  | Status |
| --------------------------- | ------ |
| AutoUpgrade analyze SUCCESS | YES    |
| AutoUpgrade fixups SUCCESS  | YES    |
| AutoUpgrade deploy SUCCESS  | YES    |
| NEXUSCDB open READ WRITE    | YES    |
| NEXUS PDB open READ WRITE   | YES    |
| Registry components VALID   | YES    |
| Invalid objects reviewed    | YES    |
| Listener services READY     | YES    |
| Restore point documented    | YES    |
| Evidence collected          | YES    |

---

# 21. Final Status

```text
PHASE 5 COMPLETED

Oracle Database 19c CDB/PDB
successfully upgraded to
Oracle AI Database 26ai

READY FOR PHASE 6

Final documentation, diagrams, troubleshooting and GitHub packaging.
```

