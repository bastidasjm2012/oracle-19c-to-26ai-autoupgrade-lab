#!/bin/bash

ORACLE_HOME_26AI="/u01/app/oracle/product/26ai/dbhome_1"

echo "Creating Oracle 26ai Home: $ORACLE_HOME_26AI"

mkdir -p "$ORACLE_HOME_26AI"

chown -R oracle:oinstall /u01/app/oracle/product/26ai

chmod -R 775 /u01/app/oracle/product/26ai

ls -ld "$ORACLE_HOME_26AI"
