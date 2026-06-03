# Troubleshooting Guide

## Oracle Database 19c to Oracle AI Database 26ai Upgrade Lab

| Issue | Phase | Possible Cause | Resolution |
|---|---|---|---|
| Leapp package not found | Phase 2 | Repository not enabled | Enable Leapp repository and retry |
| Leapp inhibitors detected | Phase 2 | Kernel, PAM, repository or package blockers | Review `/var/log/leapp/leapp-report.txt` |
| Oracle does not start after OS upgrade | Phase 2 | Environment or library issue | Validate `ORACLE_HOME`, `LD_LIBRARY_PATH`, alert log |
| DBMS_PDB compatibility returns false | Phase 3 | Parameter/component mismatch | Review `pdb_plug_in_violations` |
| PDB opens restricted | Phase 3 | Plugin violations pending | Resolve violations and rerun validation |
| 26ai installer prereq failure | Phase 4 | Missing OS packages | Install preinstall package and required RPMs |
| AutoUpgrade analyze fails | Phase 5 | Pre-upgrade issue | Review preupgrade log and rerun analyze |
| AutoUpgrade deploy fails | Phase 5 | Upgrade failure | Use `restore -job <JOB_ID>` if GRP exists |
| Invalid objects after upgrade | Phase 5 | Object recompilation required | Run `utlrp.sql` and review invalid objects |
| Listener shows wrong home | Phase 5 | Listener still running from old home | Validate listener config and environment |

## Key Logs

```text
/var/log/leapp/leapp-report.txt
/var/log/leapp/leapp-upgrade.log
/u01/app/oracle/cfgtoollogs/upgrade
/u01/app/oracle/autoupgrade/upgrade_logs
$ORACLE_BASE/diag/rdbms/*/*/trace/alert_*.log
```
