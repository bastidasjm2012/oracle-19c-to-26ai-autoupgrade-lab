#!/bin/bash
# ==================================================
# Script Name:
# 04_capture_19c_install_evidence.sh
#
# Purpose:
# Capture Oracle Database 19c Software Installation
# evidence after silent installation.
#
# Phase:
# 02 - Oracle 19c Software Installation
# Autor: Jesus Bastidas
# ==================================================

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/19/db_1

OUT=/root/evidence/phase02_oracle19c_software_install/final_validation

mkdir -p $OUT


echo "Capturing Oracle 19c software evidence..."


echo "SQLPLUS VERSION"
echo "===============" > $OUT/sqlplus_version.log

su - oracle -c "
export ORACLE_HOME=$ORACLE_HOME
$ORACLE_HOME/bin/sqlplus -v
" >> $OUT/sqlplus_version.log



echo "OPATCH VERSION"
echo "==============" > $OUT/opatch_version.log

su - oracle -c "
export ORACLE_HOME=$ORACLE_HOME
$ORACLE_HOME/OPatch/opatch version
" >> $OUT/opatch_version.log



echo "OPATCH INVENTORY"
echo "================" > $OUT/opatch_lsinventory.log

su - oracle -c "
export ORACLE_HOME=$ORACLE_HOME
$ORACLE_HOME/OPatch/opatch lsinventory
" >> $OUT/opatch_lsinventory.log



echo "ORACLE INVENTORY"
echo "================" > $OUT/orainventory.log

ls -ltr /u01/app/oraInventory \
>> $OUT/orainventory.log



echo "ORACLE HOME SIZE"
echo "================" > $OUT/oracle_home_size.log

du -sh $ORACLE_HOME \
>> $OUT/oracle_home_size.log



echo ""
echo "Evidence Capture Completed Successfully"
echo ""
echo "Output:"
echo $OUT
