set lines 220 pages 1000 trimspool on
spool /u01/stage/26ai/noncdb_to_pdb/02_create_manifest_xml.log

prompt ============================================================
prompt CREATE NON-CDB MANIFEST XML USING DBMS_PDB.DESCRIBE
prompt ============================================================

shutdown immediate;
startup open read only;

select name,
       open_mode,
       cdb
from v$database;

begin
  dbms_pdb.describe(
    pdb_descr_file => '/u01/stage/26ai/noncdb_to_pdb/NEXUS.xml'
  );
end;
/

host ls -lh /u01/stage/26ai/noncdb_to_pdb/NEXUS.xml

prompt XML Manifest generated successfully.

spool off
