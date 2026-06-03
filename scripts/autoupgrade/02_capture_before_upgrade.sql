set lines 220
set pages 5000

spool /u01/stage/26ai/DB_capture_pre_19c.txt


select sysdate from dual;


select name,
       db_unique_name,
       cdb,
       open_mode,
       log_mode
from v$database;


select banner_full
from v$version;


show pdbs


select con_id,
       comp_id,
       version,
       status
from cdb_registry
order by con_id;


select con_id,
       count(*)
from cdb_objects
where status <> 'VALID'
group by con_id;


select version
from v$timezone_file;


show parameter compatible


spool off
