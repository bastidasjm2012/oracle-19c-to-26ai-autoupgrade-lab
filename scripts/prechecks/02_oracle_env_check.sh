#!/bin/bash
# Oracle Environment Precheck

REPORT_DIR="/u01/stage/26ai/precheck_reports"
REPORT_FILE="${REPORT_DIR}/oracle_env_check_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$REPORT_DIR"

{
echo "=================================================="
echo " ORACLE ENVIRONMENT CHECK"
echo " Execution Date: $(date)"
echo " Hostname: $(hostname)"
echo "=================================================="

echo
echo "### Oracle User"
id oracle

echo
echo "### ORATAB"
cat /etc/oratab

echo
echo "### Oracle Inventory"
cat /etc/oraInst.loc

echo
echo "### Oracle Homes"
ls -ld /u01/app/oracle/product/* 2>/dev/null

echo
echo "### Running Oracle Processes"
ps -ef | grep pmon | grep -v grep

echo
echo "### Listener Processes"
ps -ef | grep tnslsnr | grep -v grep

echo
echo "### Environment Variables"
env | egrep 'ORACLE|TNS|PATH|LD_LIBRARY_PATH'

echo
echo "=================================================="
echo " END OF ORACLE ENVIRONMENT CHECK"
echo "=================================================="
} | tee "$REPORT_FILE"
