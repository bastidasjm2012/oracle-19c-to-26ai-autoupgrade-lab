set lines 200
set pages 200

spool /u01/evidence/phase05_noncdb_to_pdb/01_noncdb_precheck.log

select name, open_mode, database_role, cdb from v$database;

select instance_name, status, version from v$instance;

select owner, object_type, count(*) total
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
group by owner, object_type
order by owner, object_type;

select owner, object_name, object_type, status
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
and status <> 'VALID';

archive log list;

spool off
exit
