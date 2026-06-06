set lines 200
set pages 200
set timing on

spool /u01/evidence/phase04_workload_rman/workload_validation.log

prompt =====================================
prompt WORKLOAD OBJECT VALIDATION
prompt =====================================

select owner,
       object_type,
       count(*) total_objects
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
group by owner, object_type
order by owner, object_type;

prompt =====================================
prompt INVALID OBJECTS VALIDATION
prompt =====================================

select owner,
       object_name,
       object_type,
       status
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
and status <> 'VALID'
order by owner, object_type, object_name;

prompt =====================================
prompt ROW COUNT VALIDATION
prompt =====================================

select 'APP_CORE.CUSTOMERS' table_name,
       count(*) total_rows
from APP_CORE.CUSTOMERS
union all
select 'APP_CORE.ORDERS',
       count(*)
from APP_CORE.ORDERS
union all
select 'APP_AUDIT.ACTIVITY_LOG',
       count(*)
from APP_AUDIT.ACTIVITY_LOG;

prompt =====================================
prompt CONSTRAINT VALIDATION
prompt =====================================

select owner,
       constraint_name,
       constraint_type,
       table_name,
       status,
       validated
from dba_constraints
where owner in ('APP_CORE','APP_AUDIT')
order by owner, table_name, constraint_name;

spool off
exit
