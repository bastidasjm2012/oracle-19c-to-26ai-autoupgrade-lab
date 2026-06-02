#!/bin/bash

echo "Stopping Oracle before OS upgrade"


export ORACLE_SID=NEXUS
export ORACLE_HOME=/u01/app/oracle/product/19/db_1


echo
echo "Stopping Listener"

$ORACLE_HOME/bin/lsnrctl stop


echo
echo "Stopping Database"


sqlplus / as sysdba <<EOF

shutdown immediate;

exit

EOF


echo
echo "Verify processes"


ps -ef | grep pmon | grep -v grep

ps -ef | grep tns

echo "Oracle stopped"
