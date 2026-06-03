set lines 220 pages 50000 trimspool on
set trimspool on
spool /u01/stage/26ai/noncdb_to_pdb/07_post_conversion_validation.log

prompt ============================================================
prompt POST NON-CDB TO PDB CONVERSION VALIDATION
prompt ============================================================

select name,
       open_mode,
       cdb
from v$database;

show pdbs

alter session set container=NEXUS;

prompt Current Container
show con_name

prompt Invalid Objects
select owner,
       object_type,
       count(*) total_invalid
from dba_objects
where status <> 'VALID'
group by owner, object_type
order by owner, object_type;

prompt Registry Components
select comp_id,
       comp_name,
       version,
       status
from dba_registry
order by comp_id;

prompt Application Objects Count
select owner,
       count(*) total_objects
from dba_objects
group by owner
order by owner;

prompt PDB Violations
alter session set container=CDB$ROOT;

select name,
       cause,
       type,
       status,
       message,
       action
from pdb_plug_in_violations
where name = 'NEXUS'
order by time;

spool off
