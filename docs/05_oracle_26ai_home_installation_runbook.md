# Oracle AI Database 26ai Software Installation Runbook
## Phase 4 - New Oracle Home Parallel Installation

Author: Jesus Bastidas  
Role: Enterprise Database Architect / Senior Oracle DBA

---

# 1. Overview

This phase installs Oracle AI Database 26ai software as a new Oracle Home.

No database upgrade is executed in this phase.

Source Oracle Home:

```text
/u01/app/oracle/product/19/db_1
```

Target Oracle Home:

```text
/u01/app/oracle/product/26ai/dbhome_1
```

---

# 2. Objective

Install Oracle AI Database 26ai software-only home on Oracle Linux 8.10.

This Oracle Home will later be used by AutoUpgrade.

---

# 3. Directory Structure

```text
/u01/stage/26ai
/u01/app/oracle/product/26ai/dbhome_1
```

---

# 4. Pre-Requisites

| Check | Required |
|---|---|
| Oracle Linux 8.10 | YES |
| Oracle 19c CDB/PDB already created | YES |
| NEXUSCDB running on 19c | YES |
| RMAN backup available | YES |
| Oracle inventory healthy | YES |
| 26ai Gold Image downloaded | YES |

---

# 5. Execute Prerequisite Validation

```bash
chmod +x scripts/install_26ai_home/*.sh

./scripts/install_26ai_home/01_26ai_prereq_validation.sh
```

---

# 6. Create Oracle 26ai Home

```bash
./scripts/install_26ai_home/02_create_26ai_oracle_home.sh
```

---

# 7. Prepare Response File

Response file:

```text
response_files/db_install_26ai.rsp
```

---

# 8. Execute Silent Installation

```bash
./scripts/install_26ai_home/03_install_26ai_home_silent.sh
```

---

# 9. Run Root Scripts

As root:

```bash
/u01/app/oraInventory/orainstRoot.sh

/u01/app/oracle/product/26ai/dbhome_1/root.sh
```

---

# 10. Validate Inventory

```bash
./scripts/install_26ai_home/05_inventory_validation.sh
```

---

# 11. Compare 19c and 26ai Homes

```bash
./scripts/install_26ai_home/06_compare_19c_26ai_homes.sh
```

---

# 12. Expected Result

```text
Oracle 19c Home:
VALID

Oracle 26ai Home:
VALID

Oracle Inventory:
UPDATED

No database upgraded yet.
```

---

# 13. Evidence

```text
evidence/
└── phase04_26ai_home_installation/
    ├── prereq_validation.log
    ├── install_26ai_home.log
    ├── root_scripts_execution.md
    ├── inventory_after_install.log
    └── home_comparison.log
```

---

# 14. GO / NO-GO Checklist

| Validation | Status |
|---|---|
| Oracle Linux 8.10 validated | YES |
| 26ai Oracle Home created | YES |
| Silent install completed | YES |
| Root scripts executed | YES |
| Inventory shows 26ai Home | YES |
| Java from 26ai Home works | YES |
| SQLPlus from 26ai Home works | YES |

---

# Phase Completion

```text
READY FOR PHASE 5

AutoUpgrade 19c to 26ai
```
