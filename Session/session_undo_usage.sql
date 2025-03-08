--session with high undo usage

SELECT 
    s.sid,
    s.serial#,
    s.username,
    s.program,
    t.used_urec AS undo_records,
    t.used_ublk AS undo_blocks,
    (t.used_ublk * (SELECT value FROM v$parameter WHERE name = 'db_block_size')) / 1024 / 1024 AS undo_mb
FROM 
    v$session s
JOIN 
    v$transaction t ON s.saddr = t.ses_addr
ORDER BY 
    t.used_ublk DESC;
