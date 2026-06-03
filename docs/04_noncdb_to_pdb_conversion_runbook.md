mkdir -p /u01/stage/26ai/noncdb_to_pdb

export ORACLE_SID=NEXUS
export ORACLE_HOME=/u01/app/oracle/product/19/db_1
export PATH=$ORACLE_HOME/bin:$PATH

sqlplus / as sysdba @scripts/noncdb_to_pdb/01_source_noncdb_precheck.sql
sqlplus / as sysdba @scripts/noncdb_to_pdb/02_create_manifest_xml.sql

export ORACLE_SID=NEXUSCDB
dbca -silent -createDatabase ...

export ORACLE_SID=NEXUSCDB

sqlplus / as sysdba @scripts/noncdb_to_pdb/03_target_cdb_precheck.sql
sqlplus / as sysdba @scripts/noncdb_to_pdb/04_check_plug_compatibility.sql
sqlplus / as sysdba @scripts/noncdb_to_pdb/05_plug_noncdb_as_pdb.sql
sqlplus / as sysdba @scripts/noncdb_to_pdb/06_run_noncdb_to_pdb.sql
sqlplus / as sysdba @scripts/noncdb_to_pdb/07_post_conversion_validation.sql
sqlplus / as sysdba @scripts/noncdb_to_pdb/08_save_pdb_state.sql

prompt ============================================================
prompt  Resultado esperado:
prompt ============================================================
prompt CDB: NEXUSCDB
prompt PDB: NEXUS
prompt PDB OPEN_MODE: READ WRITE
prompt CDB: YES
prompt Invalid objects: 0 or controlled
promptRegistry components: VALID
