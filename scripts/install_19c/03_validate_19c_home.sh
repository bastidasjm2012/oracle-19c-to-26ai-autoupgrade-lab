#!/bin/bash

LOG_DIR="/root/evidence/phase02_oracle19c_software_install"
LOG_FILE="${LOG_DIR}/03_validate_19c_home_$(date +%Y%m%d_%H%M%S).log"

ORACLE_HOME="/u01/app/oracle/product/19/db_1"

{
echo "=========================================================="
echo " ORACLE 19C HOME VALIDATION"
echo " Date: $(date)"
echo "=========================================================="

echo
echo "### SQLPlus version"
su - oracle -c "${ORACLE_HOME}/bin/sqlplus -v"

echo
echo "### OPatch version"
su - oracle -c "${ORACLE_HOME}/OPatch/opatch version"

echo
echo "### Oracle Inventory"
su - oracle -c "${ORACLE_HOME}/OPatch/opatch lsinventory"

echo
echo "### Oracle Home size"
du -sh "${ORACLE_HOME}"

echo
echo "### Oracle Home permissions"
ls -ld "${ORACLE_HOME}"

echo
echo "=========================================================="
echo " ORACLE 19C SOFTWARE INSTALLATION VALIDATED"
echo "=========================================================="

} | tee "${LOG_FILE}"
