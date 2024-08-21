SELECT
    s.client_identifier,
    s.osuser,
    s.inst_id,
    s.sid,
    s.serial#,
    s.username,
    s.logon_time,
    t.tablespace,
    t.EXTENTS,
    t.segfile#,
    t.segblk#,
    t.blocks * tbs.block_size / 1024 / 1024 AS temp_space_mb,
    df.file_name,
    df.status,
    df.autoextensible,
    df.bytes / 1024 / 1024 AS file_size_mb,
    df.maxbytes / 1024 / 1024 AS max_file_size_mb
FROM
    gv$session s
JOIN
    gv$tempseg_usage t ON s.saddr = t.session_addr
JOIN
    dba_tablespaces tbs ON t.tablespace = tbs.tablespace_name
JOIN
    dba_temp_files df ON t.tablespace = df.tablespace_name
ORDER BY
    temp_space_mb DESC;
