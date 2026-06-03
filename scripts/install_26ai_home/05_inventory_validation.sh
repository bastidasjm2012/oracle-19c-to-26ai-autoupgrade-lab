#!/bin/bash

REPORT_DIR="/u01/stage/26ai/install_reports"
REPORT_FILE="${REPORT_DIR}/inventory_after_install_$(date +%Y%m%d_%H%M%S).log"

{
echo "=================================================="
echo " ORACLE INVENTORY VALIDATION"
echo " Execution Date: $(date)"
echo "=================================================="

echo
echo "### oraInst.loc"
cat /etc/oraInst.loc

echo
echo "### OPatch lsinventory - 19c"
export ORACLE_HOME=/u01/app/oracle/product/19/db_1
$ORACLE_HOME/OPatch/opatch lsinventory

echo
echo "### OPatch lsinventory - 26ai"
export ORACLE_HOME=/u01/app/oracle/product/26ai/dbhome_1
$ORACLE_HOME/OPatch/opatch lsinventory

echo
echo "=================================================="
echo " END INVENTORY VALIDATION"
echo "=================================================="
} | tee "$REPORT_FILE"
