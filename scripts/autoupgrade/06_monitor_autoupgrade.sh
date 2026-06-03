#!/bin/bash


LOG=/u01/app/oracle/cfgtoollogs/upgrade


echo "AutoUpgrade Status Files"


find $LOG -name status.log


echo


tail -100 \
$(find $LOG -name status.log)
