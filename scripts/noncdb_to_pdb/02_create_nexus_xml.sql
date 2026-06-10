set lines 200
set pages 200

spool /u01/evidence/phase05_noncdb_to_pdb/02_create_nexus_xml.log

shutdown immediate;

startup open read only;

select name, open_mode, cdb from v$database;

begin
  dbms_pdb.describe(
    pdb_descr_file => '/u01/stage/phase05_noncdb_to_pdb/NEXUS.xml'
  );
end;
/

host ls -lh /u01/stage/phase05_noncdb_to_pdb/NEXUS.xml

spool off
exit
