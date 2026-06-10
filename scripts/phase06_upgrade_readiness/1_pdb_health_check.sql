set lines 220
set pages 200

spool /u01/evidence/phase06_upgrade_readiness/01_pdb_health_check.log


prompt ===============================
prompt DATABASE INFORMATION
prompt ===============================


select
name,
open_mode,
database_role,
cdb
from v$database;


prompt ===============================
prompt INSTANCE INFORMATION
prompt ===============================


select
instance_name,
status,
version
from v$instance;


prompt ===============================
prompt PDB STATUS
prompt ===============================


show pdbs


prompt ===============================
prompt SAVED STATE
prompt ===============================


select
con_name,
state
from dba_pdb_saved_states;


prompt ===============================
prompt PDB VIOLATIONS
prompt ===============================


select
name,
cause,
type,
status,
message
from pdb_plug_in_violations
order by time;


prompt ===============================
prompt DATABASE REGISTRY
prompt ===============================


select
comp_id,
comp_name,
version,
status
from dba_registry
order by comp_id;


prompt ===============================
prompt INVALID OBJECTS CDB
prompt ===============================


select
owner,
object_type,
count(*)
from dba_objects
where status <> 'VALID'
group by owner, object_type;


alter session set container=NEXUS;


prompt ===============================
prompt CURRENT PDB
prompt ===============================


show con_name


prompt ===============================
prompt APPLICATION OBJECTS
prompt ===============================


select
owner,
object_type,
count(*)
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
group by owner, object_type
order by owner, object_type;


prompt ===============================
prompt INVALID APP OBJECTS
prompt ===============================


select
owner,
object_name,
object_type,
status
from dba_objects
where owner in ('APP_CORE','APP_AUDIT')
and status <> 'VALID';


prompt ===============================
prompt DATA VALIDATION
prompt ===============================


select count(*) CUSTOMERS
from APP_CORE.CUSTOMERS;


select count(*) ORDERS
from APP_CORE.ORDERS;


spool off

exit
