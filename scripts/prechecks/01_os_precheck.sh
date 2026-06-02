#!/bin/bash
# Oracle 19c to 26ai - OS Precheck
# Author: Jesus Bastidas

REPORT_DIR="/u01/stage/26ai/precheck_reports"
REPORT_FILE="${REPORT_DIR}/os_precheck_$(date +%Y%m%d_%H%M%S).log"

mkdir -p "$REPORT_DIR"

{
echo "=================================================="
echo " OS PRECHECK REPORT"
echo " Execution Date: $(date)"
echo " Hostname: $(hostname)"
echo "=================================================="

echo
echo "### OS Version"
cat /etc/oracle-release 2>/dev/null || cat /etc/redhat-release

echo
echo "### Kernel"
uname -a

echo
echo "### CPU / Memory"
lscpu | egrep 'CPU\(s\)|Model name|Socket|Core'
free -h

echo
echo "### Disk Space"
df -h /

df -h /boot

df -h /u01

echo
echo "### Internet Connectivity"
ping -c 3 yum.oracle.com

echo
echo "### Enabled Repositories"
yum repolist enabled 2>/dev/null || dnf repolist enabled

echo
echo "### Current User"
whoami

echo
echo "### Uptime"
uptime

echo
echo "=================================================="
echo " END OF OS PRECHECK"
echo "=================================================="
} | tee "$REPORT_FILE"
