#!/bin/bash

# =====================================================
# Create Oracle Database 19c NEXUS NON-CDB
# Phase 03
# =====================================================

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19/db_1
export ORACLE_SID=NEXUS

export PATH=$ORACLE_HOME/bin:$PATH


LOG=/tmp/create_NEXUS_$(date +%Y%m%d_%H%M).log


echo "Creating NEXUS NON-CDB database..." | tee $LOG


dbca \
-silent \
-createDatabase \
-templateName General_Purpose.dbc \
-gdbname NEXUS \
-sid NEXUS \
-createAsContainerDatabase false \
-databaseConfigType SI \
-characterSet AL32UTF8 \
-nationalCharacterSet AL16UTF16 \
-memoryMgmtType auto_sga \
-totalMemory 4096 \
-storageType FS \
-datafileDestination /u01/app/oracle/oradata \
-recoveryAreaDestination /u01/app/oracle/fast_recovery_area \
-recoveryAreaSize 10240 \
-emConfiguration NONE \
-ignorePreReqs \
-sysPassword Oracle_123 \
-systemPassword Oracle_123


echo "Completed" | tee -a $LOG
