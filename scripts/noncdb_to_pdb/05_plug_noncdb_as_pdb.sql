set lines 220 pages 1000 trimspool on
spool /u01/stage/26ai/noncdb_to_pdb/05_plug_noncdb_as_pdb.log

prompt ============================================================
prompt PLUG NON-CDB NEXUS AS PDB INTO NEXUSCDB
prompt ============================================================

create pluggable database NEXUS
using '/u01/stage/26ai/noncdb_to_pdb/NEXUS.xml'
copy
file_name_convert = (
  '/u01/app/oracle/oradata/NEXUS/',
  '/u01/app/oracle/oradata/NEXUSCDB/NEXUS/'
);

show pdbs

alter pluggable database NEXUS open restricted;

show pdbs

spool off
