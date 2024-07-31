SELECT 
    sql_id,
    SQL_OPNAME,
    INST_ID,
    MIN(sample_time) AS start_time,
    MAX(sample_time) AS end_time,
    ROUND((SUM(delta_time) / 1000000 / 60),2) AS TIME,
    ROUND((SUM(tm_delta_time) / 1000000 / 60),2) AS A_TIME,
    ROUND((SUM(tm_delta_cpu_time) / 1000000 / 60),2) AS CPU_TIME,
    SUM(delta_read_io_requests) AS "I/O READ",
    SUM(delta_write_io_requests) AS "I/O WRITE",
    ROUND((SUM(delta_read_io_bytes) / (1024 * 1024 * 1024)),2) AS "I/O READ GB",
    ROUND((SUM(delta_write_io_bytes) / (1024 * 1024 * 1024)),2) AS "I/O WRITE GB"
FROM 
    gv$active_session_history
WHERE 
    session_id = 3571
    AND session_serial# = 57114
    AND CLIENT_ID='502025410'
GROUP BY 
    sql_id,SQL_OPNAME,INST_ID
ORDER BY 
    A_TIME DESC;
	
	
	
SELECT 
    sql_id,
    SQL_OPNAME,
    INSTANCE_NUMBER,
    MIN(sample_time) AS start_time,
    MAX(sample_time) AS end_time,
    ROUND((SUM(delta_time) / 1000000 / 60),2) AS TIME,
    ROUND((SUM(tm_delta_time) / 1000000 / 60),2) AS A_TIME,
    ROUND((SUM(tm_delta_cpu_time) / 1000000 / 60),2) AS CPU_TIME,
    SUM(delta_read_io_requests) AS "I/O READ",
    SUM(delta_write_io_requests) AS "I/O WRITE",
    ROUND((SUM(delta_read_io_bytes) / (1024 * 1024 * 1024)),2) AS "I/O READ GB",
    ROUND((SUM(delta_write_io_bytes) / (1024 * 1024 * 1024)),2) AS "I/O WRITE GB"
FROM 
    DBA_HIST_ACTIVE_SESS_HISTORY
WHERE 
    session_id = 3571
    AND session_serial# = 57114
    AND CLIENT_ID='502025410'
GROUP BY 
    sql_id,SQL_OPNAME,INSTANCE_NUMBER
ORDER BY 
    A_TIME DESC;
	
