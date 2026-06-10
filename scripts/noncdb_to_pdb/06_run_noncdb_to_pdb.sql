set lines 200
set pages 200
set timing on

spool /u01/evidence/phase05_noncdb_to_pdb/06_run_noncdb_to_pdb.log

alter session set container=NEXUS;

show con_name

@$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql

alter pluggable database close immediate;
alter pluggable database open;

show pdbs

spool off
exit
