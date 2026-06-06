#!/bin/bash

export ORACLE_HOME=/u01/app/oracle/product/19/db_1
export ORACLE_SID=NEXUS
export PATH=$ORACLE_HOME/bin:$PATH

LOG=/u01/evidence/phase04_workload_rman/rman_baseline_backup_$(date +%Y%m%d_%H%M%S).log

rman target / log=$LOG <<EOF
CONFIGURE CONTROLFILE AUTOBACKUP ON;

backup as compressed backupset
database
format '/u01/backup/NEXUS/db_%U.bkp'
tag 'PHASE04_NEXUS_BASELINE_DB';

backup as compressed backupset
archivelog all
format '/u01/backup/NEXUS/arch_%U.bkp'
tag 'PHASE04_NEXUS_BASELINE_ARCH';

backup current controlfile
format '/u01/backup/NEXUS/control_%U.bkp'
tag 'PHASE04_NEXUS_BASELINE_CTL';

backup spfile
format '/u01/backup/NEXUS/spfile_%U.bkp'
tag 'PHASE04_NEXUS_BASELINE_SPFILE';

list backup summary;

exit
EOF

echo "RMAN baseline backup completed."
echo "Log: $LOG"
