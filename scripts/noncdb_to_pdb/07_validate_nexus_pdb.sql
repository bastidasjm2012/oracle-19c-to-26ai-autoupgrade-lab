set lines 200
set pages 200

spool /u01/evidence/phase05_noncdb_to_pdb/07_validate_nexus_pdb.log

select name, open_mode, cdb from v$database;

show pdbs

alter session set container=NEXUS;

select sys_context('USERENV','CON_NAME') current_container from dual;

select owner, object_type, count(*) total
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
group by owner, object_type
order by owner, object_type;

select owner, object_name, object_type, status
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
and status <> 'VALID';

select count(*) customers from APP_CORE.CUSTOMERS;

select count(*) orders from APP_CORE.ORDERS;

alter session set container=CDB$ROOT;

select name, cause, type, status, message, action
from pdb_plug_in_violations
where name = 'NEXUS'
order by time;

spool off
exit
