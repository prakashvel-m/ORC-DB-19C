SELECT s.sid, s.serial#,s.logon_time,s.SQL_EXEC_START,s.module,s.status, s.username, s.osuser, s.machine, s.program,a.object
FROM gv$session s
JOIN gv$access a ON s.sid = a.sid
WHERE a.object in ('GEWSH_APL_PRODUCT_INBD_V2_PKG') and s.status='ACTIVE'
order by SQL_EXEC_START asc;
