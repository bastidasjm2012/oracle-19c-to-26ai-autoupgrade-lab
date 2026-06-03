set lines 220 pages 1000 trimspool on
spool /u01/stage/26ai/noncdb_to_pdb/08_save_pdb_state.log

alter pluggable database NEXUS save state;

select con_name,
       state
from dba_pdb_saved_states;

spool off
