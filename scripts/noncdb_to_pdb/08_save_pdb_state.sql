set lines 200
set pages 200


spool /u01/evidence/phase05_noncdb_to_pdb/08_save_pdb_state.log


prompt =====================================
prompt SAVE PDB STATE
prompt =====================================


show pdbs


alter pluggable database NEXUS save state;


prompt =====================================
prompt VALIDATE SAVED STATE
prompt =====================================


select 
 con_name,
 state
from dba_pdb_saved_states;


spool off

exit
