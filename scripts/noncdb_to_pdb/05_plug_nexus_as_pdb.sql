set lines 200
set pages 200

spool /u01/evidence/phase05_noncdb_to_pdb/05_plug_nexus_as_pdb.log

create pluggable database NEXUS
using '/u01/stage/phase05_noncdb_to_pdb/NEXUS.xml'
copy
file_name_convert = (
  '/u01/app/oracle/oradata/NEXUS/',
  '/u01/app/oracle/oradata/NEXUSCDB/NEXUS/'
);

show pdbs

alter pluggable database NEXUS open restricted;

show pdbs

spool off
exit
