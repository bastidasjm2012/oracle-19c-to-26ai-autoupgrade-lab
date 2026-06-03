#!/bin/bash

REPORT_DIR="/u01/stage/26ai/install_reports"
REPORT_FILE="${REPORT_DIR}/prereq_validation_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$REPORT_DIR"

{
echo "=================================================="
echo " ORACLE AI DATABASE 26AI PREREQ VALIDATION"
echo " Execution Date: $(date)"
echo " Hostname: $(hostname)"
echo "=================================================="

echo
echo "### OS Version"
cat /etc/oracle-release

echo
echo "### Kernel"
uname -a

echo
echo "### Memory"
free -h

echo
echo "### Disk Space"
df -h /
df -h /u01
df -h /tmp

echo
echo "### Oracle User"
id oracle

echo
echo "### Oracle Inventory"
cat /etc/oraInst.loc
ls -ld /u01/app/oraInventory

echo
echo "### Existing Oracle Homes"
ls -ld /u01/app/oracle/product/* 2>/dev/null

echo
echo "### Required Package Preinstall"
rpm -qa | grep oracle-database-preinstall

echo
echo "### Stage Files"
ls -lh /u01/stage/26ai

echo
echo "=================================================="
echo " END PREREQ VALIDATION"
echo "=================================================="
} | tee "$REPORT_FILE"
