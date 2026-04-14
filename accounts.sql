drop table t purge;
create table t as select '123,456,789' acct from dual;
select distinct (instr(acct||',',',',1,level)) loc
from t
connect by level <= length(acct)- length(replace(acct,','))+1;
