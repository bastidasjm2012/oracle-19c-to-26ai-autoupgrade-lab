#!/bin/bash

REPORT_DIR="/u01/stage/26ai/install_reports"
REPORT_FILE="${REPORT_DIR}/home_comparison_$(date +%Y%m%d_%H%M%S).log"

HOME19="/u01/app/oracle/product/19/db_1"
HOME26="/u01/app/oracle/product/26ai/dbhome_1"

{
echo "=================================================="
echo " ORACLE HOME COMPARISON"
echo " Execution Date: $(date)"
echo "=================================================="

echo
echo "### 19c Home"
echo "$HOME19"
ls -ld "$HOME19"
du -sh "$HOME19"

echo
echo "### 26ai Home"
echo "$HOME26"
ls -ld "$HOME26"
du -sh "$HOME26"

echo
echo "### SQLPlus Version - 19c"
$HOME19/bin/sqlplus -v

echo
echo "### SQLPlus Version - 26ai"
$HOME26/bin/sqlplus -v

echo
echo "### Java Version - 19c"
$HOME19/jdk/bin/java -version 2>&1

echo
echo "### Java Version - 26ai"
$HOME26/jdk/bin/java -version 2>&1

echo
echo "### OPatch Version - 19c"
$HOME19/OPatch/opatch version

echo
echo "### OPatch Version - 26ai"
$HOME26/OPatch/opatch version

echo
echo "=================================================="
echo " END ORACLE HOME COMPARISON"
echo "=================================================="
} | tee "$REPORT_FILE"
