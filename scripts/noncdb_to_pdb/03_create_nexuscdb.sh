#!/bin/bash

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19/db_1
export ORACLE_SID=NEXUSCDB
export PATH=$ORACLE_HOME/bin:$PATH

LOG=/u01/evidence/phase05_noncdb_to_pdb/03_create_nexuscdb_$(date +%Y%m%d_%H%M%S).log

dbca -silent -createDatabase \
-templateName General_Purpose.dbc \
-gdbname NEXUSCDB \
-sid NEXUSCDB \
-createAsContainerDatabase true \
-numberOfPDBs 0 \
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
-systemPassword Oracle_123 | tee $LOG
