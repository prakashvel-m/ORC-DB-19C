SELECT 
    TRUNC(sn.begin_interval_time) AS day,
    ts.name AS tablespace_name,
    o.object_name,
    SUM(s.logical_reads_total) AS logical_rt,
    SUM(s.logical_reads_delta) AS logical_rd,
    SUM(s.db_block_changes_total) AS db_bct,
    SUM(s.db_block_changes_delta) AS db_bcd,
    SUM(s.physical_reads_total) AS physical_rt,
    SUM(s.physical_reads_delta) AS physical_rd,
    SUM(s.physical_writes_total) AS physical_wt,
    SUM(s.physical_writes_delta) AS physical_wd
FROM 
    DBA_HIST_SEG_STAT s
JOIN 
    DBA_HIST_SNAPSHOT sn ON s.snap_id = sn.snap_id
JOIN 
    V$TABLESPACE ts ON s.ts# = ts.ts#
JOIN 
    DBA_OBJECTS o ON s.obj# = o.object_id
WHERE 
    o.object_name = 'TABLE_NAME'
GROUP BY 
    TRUNC(sn.begin_interval_time),
    ts.name,
    o.object_name
ORDER BY 
    day desc;
