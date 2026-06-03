set lines 220 pages 50000 trimspool on
spool /u01/backup/26ai_preupgrade/rman_backup_summary_sql.log
select session_key, input_type, status, start_time, end_time, elapsed_seconds/60 elapsed_min
from v$rman_backup_job_details
order by start_time desc fetch first 20 rows only;
select count(*) total_backups from v$backup_set;
spool off
