#!/bin/bash
set -euo pipefail
mkdir -p /u01/backup/26ai_preupgrade
rman target / cmdfile=scripts/backup/01_rman_full_backup.rcv log=/u01/backup/26ai_preupgrade/rman_full_backup.log
