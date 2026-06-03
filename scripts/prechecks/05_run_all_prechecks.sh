#!/bin/bash
# Execute all Phase 1 prechecks in order.
set -euo pipefail
export ORACLE_SID=${ORACLE_SID:-NEXUS}
export ORACLE_HOME=${ORACLE_HOME:-/u01/app/oracle/product/19/db_1}
export PATH=$ORACLE_HOME/bin:$PATH
mkdir -p /u01/stage/26ai/precheck_reports
./scripts/prechecks/01_os_precheck.sh
./scripts/prechecks/02_oracle_env_check.sh
sqlplus / as sysdba @scripts/prechecks/03_db_preupgrade_capture.sql
./scripts/prechecks/04_listener_check.sh
