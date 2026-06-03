set serveroutput on
set lines 220 pages 1000 trimspool on
spool /u01/stage/26ai/noncdb_to_pdb/04_check_plug_compatibility.log

prompt ============================================================
prompt CHECK PLUG COMPATIBILITY
prompt ============================================================

declare
  l_result boolean;
begin
  l_result := dbms_pdb.check_plug_compatibility(
                pdb_descr_file => '/u01/stage/26ai/noncdb_to_pdb/NEXUS.xml',
                pdb_name       => 'NEXUS');

  if l_result then
    dbms_output.put_line('RESULT: COMPATIBLE');
  else
    dbms_output.put_line('RESULT: NOT COMPATIBLE');
  end if;
end;
/

prompt ============================================================
prompt PDB PLUG-IN VIOLATIONS
prompt ============================================================

col name format a20
col cause format a35
col type format a12
col message format a100
col status format a12
col action format a100

select name,
       cause,
       type,
       status,
       message,
       action
from pdb_plug_in_violations
where name = 'NEXUS'
order by time;

spool off
