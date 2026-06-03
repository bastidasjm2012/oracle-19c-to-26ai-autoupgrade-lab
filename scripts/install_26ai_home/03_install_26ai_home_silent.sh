#!/bin/bash

STAGE_DIR="/u01/stage/26ai"
ORACLE_HOME_26AI="/u01/app/oracle/product/26ai/dbhome_1"
RESPONSE_FILE="/u01/stage/26ai/repo/response_files/db_install_26ai.rsp"
LOG_DIR="/u01/stage/26ai/install_reports"
LOG_FILE="${LOG_DIR}/install_26ai_home_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$LOG_DIR"

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_HOME_26AI
export PATH=$ORACLE_HOME/bin:$PATH

cd "$ORACLE_HOME_26AI" || exit 1

echo "Unzipping Oracle 26ai Gold Image..."
unzip -oq "$STAGE_DIR/LINUX.X64_2326100_db_home.zip"

echo "Starting Oracle 26ai silent installation..."

./runInstaller \
-silent \
-responseFile "$RESPONSE_FILE" \
-waitforcompletion \
-ignorePrereqFailure | tee "$LOG_FILE"

echo
echo "If installation completed successfully, run root scripts as root."
