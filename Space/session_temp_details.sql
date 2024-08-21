SELECT
    s.sid,
    s.serial#,
    s.username,
    su.tablespace,
    su.segtype,
    SUM(su.blocks * ts.block_size) / (1024 * 1024) AS used_mb
FROM
    v$session s
JOIN
    v$sort_usage su ON s.saddr = su.session_addr
JOIN
    dba_tablespaces ts ON su.tablespace = ts.tablespace_name
WHERE
    s.sid = :sid AND s.serial# = :serial# -- Replace with your session ID and serial number
GROUP BY
    s.sid,
    s.serial#,
    s.username,
    su.tablespace,
    su.segtype,
    ts.block_size
ORDER BY
    s.sid,
    su.tablespace;
