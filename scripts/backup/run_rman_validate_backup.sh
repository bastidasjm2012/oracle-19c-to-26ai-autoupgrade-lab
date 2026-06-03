#!/bin/bash
set -euo pipefail
mkdir -p /u01/backup/26ai_preupgrade
rman target / cmdfile=scripts/backup/02_rman_validate_backup.rcv log=/u01/backup/26ai_preupgrade/rman_validate_backup.log
