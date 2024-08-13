-- Get the Session SID , PID
select s.client_identifier, p.spid,s.sid, s.serial#,s.username, s.osuser
from gv$session s, gv$process p
where s.paddr= p.addr
and s.sid='&sid'
and s.serial#='&serial#'
and s.client_identifier='123456'
order by s.sid;

-- query to get the current session sid 
select distinct(sid) from v$mystat;

oradebug setospid 9594; --SPID from the above query
oradebug unlimit;
oradebug event 10046 trace name context forever,level 12;
oradebug tracefile_name;
oradebug event 10046 trace name context off;

