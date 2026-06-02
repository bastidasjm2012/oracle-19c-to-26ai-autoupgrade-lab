#!/bin/bash
#
# Oracle Linux 7.9 to 8.10
# Leapp Precheck Analyzer
#

LOG=/u01/stage/26ai/leapp_precheck_$(date +%Y%m%d_%H%M).log


{
echo "================================="
echo " LEAPP PRECHECK"
echo " Date: $(date)"
echo "================================="


echo
echo "### OS VERSION"

cat /etc/oracle-release


echo
echo "### Kernel"

uname -r


echo
echo "### Space"

df -h /
df -h /boot
df -h /u01


echo
echo "### Install LEAPP"

yum install -y leapp-upgrade


echo
echo "### Execute preupgrade"

leapp preupgrade


echo
echo "### Report location"

ls -ltr /var/log/leapp/


echo
echo "Review:"
echo "/var/log/leapp/leapp-report.txt"

} | tee $LOG
