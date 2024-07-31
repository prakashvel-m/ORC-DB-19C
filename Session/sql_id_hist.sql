SELECT
    ss.snap_id,
    ss.instance_number AS node,
    TO_CHAR(ss.begin_interval_time, 'DD/MM/YY HH24:MI') AS begin_interval_time,
    s.sql_id,
    s.plan_hash_value,
    NVL(s.executions_delta, 0) AS execs,
    ROUND(((s.elapsed_time_delta / DECODE(NVL(s.executions_delta, 0), 0, 1, s.executions_delta)) / 1000000), 2) AS avg_etime,
    ROUND((s.buffer_gets_delta / DECODE(NVL(s.buffer_gets_delta, 0), 0, 1, s.executions_delta)), 2) AS avg_lio,
    NVL(s.rows_processed_delta, 0) AS rows_processed,
    ROUND((NVL(s.PHYSICAL_READ_BYTES_DELTA, 0) / (1024 * 1024 * 1024)),2)  AS io_read_gb,
    ROUND((NVL(s.PHYSICAL_WRITE_BYTES_DELTA, 0) / (1024 * 1024 * 1024)),2) AS io__write_gb,
    NVL(s.PHYSICAL_READ_REQUESTS_DELTA, 0) AS io_read,
    NVL(s.PHYSICAL_WRITE_REQUESTS_DELTA, 0) AS io_write
FROM
    DBA_HIST_SQLSTAT s
JOIN
    DBA_HIST_SNAPSHOT ss ON ss.snap_id = s.snap_id AND ss.instance_number = s.instance_number
WHERE
    s.sql_id = 'gtwbjpyd6u9d0'
    AND s.executions_delta > 0
ORDER BY
    ss.begin_interval_time DESC;

--------------------------------------------------------------------------------------------------------

SELECT 
    ss.snap_id,
    ss.instance_number AS node,
    ss.begin_interval_time,
    s.sql_id,
    s.plan_hash_value,
    NVL(s.executions_delta, 0) AS execs,
    ROUND(((s.elapsed_time_delta / DECODE(NVL(s.executions_delta, 0), 0, 1, s.executions_delta)) / 1000000), 2) AS avg_etime,
    ROUND((s.buffer_gets_delta / DECODE(NVL(s.buffer_gets_delta, 0), 0, 1, s.executions_delta)), 2) AS avg_lio,
    NVL(s.rows_processed_delta, 0) AS rows_processed
FROM 
    DBA_HIST_SQLSTAT s
JOIN 
    DBA_HIST_SNAPSHOT ss ON ss.snap_id = s.snap_id AND ss.instance_number = s.instance_number
WHERE 
    s.sql_id = '0xs5qu2h46bf1'
    AND s.executions_delta > 0
ORDER BY 
    ss.begin_interval_time ASC;

--------------------------------------------------------------------------------------------------------

SELECT 
    s.SQL_ID,
    s.PLAN_HASH_VALUE,
    SUM(s.EXECUTIONS_DELTA) AS EXECUTIONS,
    MAX(CASE WHEN s.EXECUTIONS_DELTA = 0 THEN NULL ELSE s.ELAPSED_TIME_DELTA / s.EXECUTIONS_DELTA END) AS AVG_ELAPSED_TIME,
    MAX(CASE WHEN s.EXECUTIONS_DELTA = 0 THEN NULL ELSE s.CPU_TIME_DELTA / s.EXECUTIONS_DELTA END) AS AVG_CPU_TIME,
    MAX(CASE WHEN s.EXECUTIONS_DELTA = 0 THEN NULL ELSE s.DISK_READS_DELTA / s.EXECUTIONS_DELTA END) AS AVG_DISK_READS,
    MAX(CASE WHEN s.EXECUTIONS_DELTA = 0 THEN NULL ELSE s.BUFFER_GETS_DELTA / s.EXECUTIONS_DELTA END) AS AVG_BUFFER_GETS,
    MAX(CASE WHEN s.EXECUTIONS_DELTA = 0 THEN NULL ELSE s.PARSE_CALLS_DELTA / s.EXECUTIONS_DELTA END) AS AVG_PARSE_CALLS,
    MAX(s.OPTIMIZER_COST) AS COST,
    MIN(s.SNAP_ID) AS FIRST_SNAP_ID,
    MAX(s.SNAP_ID) AS LAST_SNAP_ID,
    MIN(ss.BEGIN_INTERVAL_TIME) AS FIRST_EXECUTION_DATE,
    MAX(ss.END_INTERVAL_TIME) AS LAST_EXECUTION_DATE
FROM 
    DBA_HIST_SQLSTAT s
JOIN 
    DBA_HIST_SNAPSHOT ss ON s.SNAP_ID = ss.SNAP_ID
WHERE 
    s.SQL_ID = 'f7c01xwcug3r5'
GROUP BY 
    s.SQL_ID, 
    s.PLAN_HASH_VALUE
ORDER BY 
    MAX(ss.END_INTERVAL_TIME) DESC;
	
	
