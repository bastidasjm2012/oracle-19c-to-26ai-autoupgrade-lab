set lines 200
set pages 200

spool /u01/evidence/phase05_noncdb_to_pdb/05_plug_nexus_as_pdb.log

alter pluggable database NEXUS save state;

select con_name,
       state
from dba_pdb_saved_states;

spool off
exit
