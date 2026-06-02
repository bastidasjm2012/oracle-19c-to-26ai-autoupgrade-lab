set lines 220
set pages 50000
set trimspool on
set serveroutput on
set feedback on
set timing on

spool /u01/stage/26ai/precheck_reports/db_preupgrade_capture_19c.log

prompt ==================================================
prompt DATABASE PRE-UPGRADE CAPTURE - ORACLE 19C
prompt ==================================================

alter session set nls_date_format='YYYY-MM-DD HH24:MI:SS';

prompt
prompt ### Capture Date
select sysdate as capture_date from dual;

prompt
prompt ### Database Information
select name, db_unique_name, database_role, open_mode, log_mode, cdb from v$database;

prompt
prompt ### Instance Information
select instance_name, host_name, version, status, database_status from v$instance;

prompt
prompt ### Version Banner
select banner_full from v$version;

prompt
prompt ### PDB Status
show pdbs

prompt
prompt ### Registry Components
select comp_id, comp_name, version, status
from dba_registry
order by comp_id;

prompt
prompt ### Invalid Objects
select owner, object_type, count(*) total
from dba_objects
where status <> 'VALID'
group by owner, object_type
order by owner, object_type;

prompt
prompt ### Tablespaces
select tablespace_name, status, contents, bigfile
from dba_tablespaces
order by tablespace_name;

prompt
prompt ### Datafiles
select file#, name, status, bytes/1024/1024 size_mb
from v$datafile
order by file#;

prompt
prompt ### Tempfiles
select file#, name, status, bytes/1024/1024 size_mb
from v$tempfile
order by file#;

prompt
prompt ### Redo Logs
select group#, thread#, sequence#, bytes/1024/1024 size_mb, status, archived
from v$log
order by group#;

prompt
prompt ### Archive Mode
archive log list

prompt
prompt ### Parameters
show parameter db_name
show parameter db_unique_name
show parameter compatible
show parameter sga
show parameter pga
show parameter processes
show parameter open_cursors
show parameter undo
show parameter audit
show parameter local_listener
show parameter remote_listener

prompt
prompt ### Timezone File
select version from v$timezone_file;

prompt
prompt ### Users Summary
select username, account_status, default_tablespace, temporary_tablespace
from dba_users
order by username;

prompt
prompt ### Object Count by Owner
select owner, count(*) total_objects
from dba_objects
group by owner
order by owner;

prompt
prompt ### Database Options
select parameter, value
from v$option
order by parameter;

prompt
prompt ==================================================
prompt END DATABASE PRE-UPGRADE CAPTURE
prompt ==================================================

spool off
