#!/bin/bash


REPORT=/u01/stage/26ai/post_os_upgrade.log


{

echo "=============================="
echo " POST OS UPGRADE VALIDATION"
echo "=============================="


date


echo

echo "=================================="
echo "OS VERSION"
echo "=================================="
echo " Oracle Linux Server release 8.10"
echo "=================================="

cat /etc/oracle-release


echo

echo "Kernel"

uname -a


echo

echo "Oracle Files"

ls -ld /u01/app/oracle


echo

echo "Oracle Processes"

ps -ef | grep oracle


echo

echo "Start Listener"


export ORACLE_HOME=/u01/app/oracle/product/19/db_1
export ORACLE_SID=NEXUS


$ORACLE_HOME/bin/lsnrctl start


sqlplus / as sysdba <<EOF

startup;

select name,open_mode,cdb
from v\$database;

select version
from v\$instance;

exit

EOF


} | tee $REPORT
