set lines 200
set pages 200

spool /u01/evidence/phase05_noncdb_to_pdb/01_noncdb_precheck.log

prompt ============================================================
prompt SOURCE NON-CDB PRECHECK - NEXUS
prompt ============================================================

alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';

select sysdate capture_date from dual;

select name,
       db_unique_name,
       open_mode,
       log_mode,
       cdb,
       database_role
from v$database;

select instance_name,
       host_name,
       version,
       status
from v$instance;

select comp_id,
       comp_name,
       version,
       status
from dba_registry
order by comp_id;

select owner, object_type, count(*) total
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
group by owner, object_type
order by owner, object_type;

select owner,
       object_type,
       count(*) total_invalid
from dba_objects
where status <> 'VALID'
group by owner, object_type
order by owner, object_type;

select owner, object_name, object_type, status
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
and status <> 'VALID';

select tablespace_name,
       status,
       contents
from dba_tablespaces
order by tablespace_name;

select count(*) total_users
from dba_users;

select username,
       account_status,
       default_tablespace,
       temporary_tablespace
from dba_users
order by username;

select version timezone_file_version
from v$timezone_file;

show parameter compatible
show parameter db_name
show parameter db_unique_name
show parameter local_listener
show parameter remote_listener

archive log list;

prompt ============================================================
prompt VALIDATION RULE
prompt CDB column must be NO before conversion.
prompt ============================================================



spool off
exit
