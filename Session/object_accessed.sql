SELECT s.sid, s.serial#,s.logon_time,s.SQL_EXEC_START,s.module,s.status, s.username, s.osuser, s.machine, s.program,a.object
FROM gv$session s
JOIN gv$access a ON s.sid = a.sid
WHERE a.object in ('GEWSH_APL_PRODUCT_INBD_V2_PKG') and s.status='ACTIVE'
order by SQL_EXEC_START asc;


SELECT 
    s.sid,
    s.serial#,
    s.username,
    s.osuser,
    s.program,
    ds.tablespace_name,
    do.object_name,
    SUM(ds.bytes) / 1024 / 1024 / 1024 AS Object_Size
FROM 
    gv$session s
JOIN 
    gv$locked_object lo ON s.sid = lo.session_id AND s.inst_id = lo.inst_id
JOIN 
    dba_objects do ON lo.object_id = do.object_id
JOIN 
    dba_segments ds ON do.owner = ds.owner AND do.object_name = ds.segment_name
WHERE 
    s.sid = 5662 
    AND s.serial# = 26766
GROUP BY 
    s.sid, s.serial#, s.username, s.osuser, s.program, ds.tablespace_name,do.object_name;
