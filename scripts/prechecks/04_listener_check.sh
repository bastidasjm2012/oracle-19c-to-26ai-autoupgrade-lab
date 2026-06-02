#!/bin/bash
# Listener Precheck

REPORT_DIR="/u01/stage/26ai/precheck_reports"
REPORT_FILE="${REPORT_DIR}/listener_check_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$REPORT_DIR"

{
echo "=================================================="
echo " LISTENER CHECK"
echo " Execution Date: $(date)"
echo " Hostname: $(hostname)"
echo "=================================================="

echo
echo "### Listener Status"
lsnrctl status

echo
echo "### Listener Services"
lsnrctl services

echo
echo "### Network Admin Files"
ls -l $ORACLE_HOME/network/admin

echo
echo "### listener.ora"
cat $ORACLE_HOME/network/admin/listener.ora 2>/dev/null

echo
echo "### tnsnames.ora"
cat $ORACLE_HOME/network/admin/tnsnames.ora 2>/dev/null

echo
echo "=================================================="
echo " END LISTENER CHECK"
echo "=================================================="
} | tee "$REPORT_FILE"
