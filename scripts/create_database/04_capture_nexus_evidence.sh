#!/bin/bash

# ===================================================
# Capture NEXUS NON-CDB Database Evidence
# Phase 03
# ===================================================

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19/db_1
export ORACLE_SID=NEXUS
export PATH=$ORACLE_HOME/bin:$PATH


OUT=/u01/evidence/phase03_nexus_noncdb/validation


mkdir -p $OUT


echo "Capturing NEXUS database evidence..."


sqlplus / as sysdba <<EOF > $OUT/database_status.log

set lines 200
set pages 200

prompt DATABASE INFORMATION

select
name,
open_mode,
database_role,
cdb
from v\$database;


prompt INSTANCE INFORMATION

select
instance_name,
status,
version
from v\$instance;


prompt ARCHIVELOG INFORMATION

archive log list;


prompt FORCE LOGGING

select
force_logging
from v\$database;


prompt COMPATIBLE PARAMETER

show parameter compatible;


exit

EOF


echo "Evidence completed:"
echo $OUT/database_status.log
