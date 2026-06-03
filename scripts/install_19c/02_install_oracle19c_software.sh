#!/bin/bash
# ==========================================================
# Oracle 19c Software Installation - Silent Mode
# Oracle 19c to Oracle AI Database 26ai Upgrade Lab
# Execute as: root
# ==========================================================

set -e

LOG_DIR="/root/evidence/phase02_oracle19c_software_install"
LOG_FILE="${LOG_DIR}/02_install_oracle19c_software_$(date +%Y%m%d_%H%M%S).log"

ORACLE_HOME="/u01/app/oracle/product/19/db_1"
SOFTWARE_ZIP="/u01/software/19c/LINUX.X64_193000_db_home.zip"
RESPONSE_FILE="/u01/software/19c/response/db_install_19c.rsp"

mkdir -p "${LOG_DIR}"

{
echo "=========================================================="
echo " PHASE 02 - ORACLE DATABASE 19C SOFTWARE INSTALLATION"
echo " Date: $(date)"
echo " Hostname: $(hostname)"
echo "=========================================================="

echo
echo "### Validate software zip"
ls -lh "${SOFTWARE_ZIP}"

echo
echo "### Validate Oracle Home"
ls -ld "${ORACLE_HOME}"

echo
echo "### Unzip Oracle 19c software into ORACLE_HOME"
su - oracle -c "cd ${ORACLE_HOME} && unzip -oq ${SOFTWARE_ZIP}"

echo
echo "### Execute runInstaller silent"
su - oracle -c "cd ${ORACLE_HOME} && ./runInstaller \
-silent \
-responseFile ${RESPONSE_FILE} \
-waitforcompletion \
-ignorePrereqFailure"

echo
echo "=========================================================="
echo " INSTALLER COMPLETED"
echo " IMPORTANT: Run root scripts manually as root if requested"
echo "=========================================================="

} | tee "${LOG_FILE}"
