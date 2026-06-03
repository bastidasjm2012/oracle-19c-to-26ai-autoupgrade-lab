#!/bin/bash


export ORACLE_HOME=/u01/app/oracle/product/26ai/dbhome_1

export PATH=$ORACLE_HOME/bin:$ORACLE_HOME/jdk/bin:$PATH


java \
-jar /u01/app/oracle/autoupgrade/autoupgrade.jar \
-config /u01/app/oracle/autoupgrade/autoupg.cfg \
-mode fixups

echo Debe finalizar:
echo PREFIXUPS

echo SUCCESS
