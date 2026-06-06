set echo on
set timing on

spool /u01/evidence/phase04_workload_rman/create_schema.log


prompt ===================================
prompt CREATE APPLICATION SCHEMAS
prompt ===================================


create user APP_CORE
identified by Oracle123
default tablespace USERS
quota unlimited on USERS;


create user APP_AUDIT
identified by Oracle123
default tablespace USERS
quota unlimited on USERS;



grant connect, resource to APP_CORE;

grant connect, resource to APP_AUDIT;



grant create view,
      create procedure,
      create sequence
to APP_CORE;



prompt ===================================
prompt CREATE TABLES
prompt ===================================


create table APP_CORE.CUSTOMERS
(
CUSTOMER_ID number primary key,
FIRST_NAME varchar2(100),
LAST_NAME varchar2(100),
EMAIL varchar2(200),
CREATED_DATE date
);



create table APP_CORE.ORDERS
(
ORDER_ID number primary key,
CUSTOMER_ID number,
ORDER_DATE date,
AMOUNT number(10,2),
constraint FK_ORDER_CUSTOMER
foreign key (CUSTOMER_ID)
references APP_CORE.CUSTOMERS(CUSTOMER_ID)
);



create table APP_AUDIT.ACTIVITY_LOG
(
LOG_ID number primary key,
ACTION varchar2(200),
CREATED_DATE date
);



prompt ===================================
prompt SEQUENCES
prompt ===================================


create sequence APP_CORE.SEQ_CUSTOMERS;

create sequence APP_CORE.SEQ_ORDERS;

create sequence APP_AUDIT.SEQ_LOG;


prompt ===================================
prompt PROCEDURE
prompt ===================================


create or replace procedure APP_CORE.ADD_CUSTOMER
(
p_name varchar2
)
as
begin

insert into APP_CORE.CUSTOMERS
values
(
APP_CORE.SEQ_CUSTOMERS.nextval,
p_name,
'TEST',
p_name||'@demo.com',
sysdate
);

commit;

end;
/



prompt ===================================
prompt INSERT DATA
prompt ===================================


begin

for i in 1..10000 loop


APP_CORE.ADD_CUSTOMER('CUSTOMER_'||i);


end loop;


commit;


end;
/



insert into APP_CORE.ORDERS
select
level,
level,
sysdate,
dbms_random.value(10,5000)
from dual
connect by level <=10000;


commit;



prompt ===================================
prompt GATHER STATISTICS
prompt ===================================


exec dbms_stats.gather_schema_stats('APP_CORE');

exec dbms_stats.gather_schema_stats('APP_AUDIT');


spool off
exit
