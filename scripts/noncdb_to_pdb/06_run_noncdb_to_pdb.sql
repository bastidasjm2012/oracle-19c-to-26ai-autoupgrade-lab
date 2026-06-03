set lines 220 pages 50000 trimspool on
spool /u01/stage/26ai/noncdb_to_pdb/06_run_noncdb_to_pdb.log

prompt ============================================================
prompt RUN noncdb_to_pdb.sql
prompt ============================================================

alter session set container=NEXUS;

show con_name

@$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql

prompt ============================================================
prompt CLOSE AND OPEN PDB READ WRITE
prompt ============================================================

alter pluggable database close immediate;
alter pluggable database open;

show pdbs

spool off
