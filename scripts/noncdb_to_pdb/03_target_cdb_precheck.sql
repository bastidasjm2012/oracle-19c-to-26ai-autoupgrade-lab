set lines 220 pages 50000 trimspool on
spool /u01/stage/26ai/noncdb_to_pdb/03_target_cdb_precheck.log

prompt ============================================================
prompt TARGET CDB PRECHECK - NEXUSCDB
prompt ============================================================

select name,
       db_unique_name,
       open_mode,
       cdb
from v$database;

show pdbs

select comp_id,
       comp_name,
       version,
       status
from dba_registry
order by comp_id;

select property_name,
       property_value
from database_properties
where property_name in (
  'NLS_CHARACTERSET',
  'NLS_NCHAR_CHARACTERSET',
  'DST_PRIMARY_TT_VERSION'
)
order by property_name;

show parameter compatible
show parameter db_name

prompt ============================================================
prompt VALIDATION RULE
prompt CDB column must be YES.
prompt ============================================================

spool off
