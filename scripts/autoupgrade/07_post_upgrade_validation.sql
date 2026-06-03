set lines 220
set pages 5000

spool /u01/stage/26ai/DB_capture_post_26ai.txt


select banner_full
from v$version;


select name,
       open_mode,
       cdb
from v$database;


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


select flashback_on
from v$database;


show parameter compatible

prompt Resultado:
 prompt Oracle AI Database 26ai

 prompt NEXUSCDB

 prompt YES


 prompt PDB:

 prompt NEXUS

 prompt READ WRITE


 prompt Registry:

 prompt VALID




spool off
