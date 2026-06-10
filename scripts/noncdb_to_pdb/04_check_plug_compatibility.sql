set serveroutput on
set lines 200
set pages 200

spool /u01/evidence/phase05_noncdb_to_pdb/04_check_plug_compatibility.log

select name, open_mode, cdb from v$database;

declare
  l_result boolean;
begin
  l_result := dbms_pdb.check_plug_compatibility(
    pdb_descr_file => '/u01/stage/phase05_noncdb_to_pdb/NEXUS.xml',
    pdb_name       => 'NEXUS'
  );

  if l_result then
    dbms_output.put_line('RESULT: COMPATIBLE');
  else
    dbms_output.put_line('RESULT: NOT COMPATIBLE');
  end if;
end;
/

select name, cause, type, status, message, action
from pdb_plug_in_violations
where name = 'NEXUS'
order by time;

spool off
exit
