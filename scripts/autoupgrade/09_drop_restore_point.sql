set lines 200


select name,
       time
from v$restore_point;


prompt Drop only after business validation


/*
DROP RESTORE POINT AUTOUPGRADE_xxxxx;
*/
