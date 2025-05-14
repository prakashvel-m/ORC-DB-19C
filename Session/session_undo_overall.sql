

select a.inst_id,a.sid, a.serial#, a.username, b.used_urec used_undo_record, b.used_ublk used_undo_blocks
from gv$session a, gv$transaction b
where a.saddr=b.ses_addr and a.inst_id=b.inst_id;


SELECT *
FROM gv$sesstat
WHERE SID = &session_id  -- Replace &session_id with the session's SID
AND statistic# in (SELECT statistic# FROM gv$statname WHERE NAME = 'user commits');

SELECT
    s.sid,
    s.serial#,
    s.program,
    s.module,
    s.username,
    ROUND(SUM(ss.value) / 1024 / 1024 /1024, 2) AS undo_usage_gb
FROM
    gv$session s
    JOIN gv$sesstat ss ON s.sid = ss.sid
    JOIN gv$statname sn ON ss.statistic# = sn.statistic#
WHERE
    sn.name = 'undo change vector size'
    AND s.sid in (7373) and s.serial# in (60211)
    AND s.username IS NOT NULL
GROUP BY
    s.sid,
    s.serial#,
    s.program,
    s.module,
    s.username;
