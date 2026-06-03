#!/bin/bash


export ORACLE_HOME=/u01/app/oracle/product/26ai/dbhome_1

export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/bin:$PATH


java \
-jar /u01/app/oracle/autoupgrade/autoupgrade.jar \
-config /u01/app/oracle/autoupgrade/autoupg.cfg \
-mode deploy


echo Durante deploy:

echo SETUP

echo GRP

echo PRECHECKS

echo PREFIXUPS

echo DRAIN

echo DBUPGRADE

echo POSTCHECKS

echo POSTFIXUPS

echo POSTUPGRADE

echo SYSUPDATES
