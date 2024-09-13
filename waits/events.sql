--WAIT CLASS -WAIT EVENTS %
 
WITH total_cluster_waits AS (
    SELECT
        SUM(TOTAL_WAITS) AS total_waits
    FROM
        gv$system_event
    WHERE
        WAIT_CLASS = 'Cluster'
)
SELECT
    se.INST_ID,
    se.EVENT,
    se.TOTAL_WAITS,
    se.TOTAL_TIMEOUTS,
    ROUND(se.TIME_WAITED_MICRO / 60000000, 2) AS TIME_WAITED_MINUTES,
    se.WAIT_CLASS,
    ROUND((se.TOTAL_WAITS / tcw.total_waits) * 100, 2) AS PERCENTAGE_WAIT
FROM
    gv$system_event se,
    total_cluster_waits tcw
WHERE
    se.WAIT_CLASS = 'Cluster'
ORDER BY
    se.TOTAL_WAITS DESC;
 
-- TOTAL WAIT EVENT %
 
WITH total_system_waits AS (
    SELECT
        SUM(TOTAL_WAITS) AS total_waits
    FROM
        gv$system_event
)
SELECT
    se.INST_ID,
    se.EVENT,
    se.TOTAL_WAITS,
    se.TOTAL_TIMEOUTS,
    ROUND(se.TIME_WAITED_MICRO / 60000000, 2) AS TIME_WAITED_MINUTES,
    se.WAIT_CLASS,
    ROUND((se.TOTAL_WAITS / tsw.total_waits) * 100, 2) AS PERCENTAGE_WAIT
FROM
    gv$system_event se,
    total_system_waits tsw
ORDER BY
    se.TOTAL_WAITS DESC;
 
-- TOTAL WAIT CLASS %
 
WITH total_system_waits AS (
    SELECT
        SUM(TOTAL_WAITS) AS total_waits
    FROM
        gv$system_event
),
wait_class_totals AS (
    SELECT
        WAIT_CLASS,
        SUM(TOTAL_WAITS) AS WAIT_CLASS_TOTAL_WAITS
    FROM
        gv$system_event
    GROUP BY
        WAIT_CLASS
)
SELECT
    wct.WAIT_CLASS,
    wct.wait_class_total_waits,
    ROUND((wct.wait_class_total_waits / tsw.total_waits) * 100, 2) AS PERCENTAGE_WAIT
FROM
    wait_class_totals wct,
    total_system_waits tsw
ORDER BY
    wct.wait_class_total_waits DESC;
-- TOTAL WAIT CLASS PER INSTANCE
 
WITH total_system_waits AS (
    SELECT
        SUM(TOTAL_WAITS) AS total_waits
    FROM
        gv$system_event
),
wait_class_totals AS (
    SELECT
        INST_ID,
        WAIT_CLASS,
        SUM(TOTAL_WAITS) AS wait_class_total_waits
    FROM
        gv$system_event
    GROUP BY
        INST_ID, WAIT_CLASS
)
SELECT
    wct.INST_ID,
    wct.WAIT_CLASS,
    wct.wait_class_total_waits,
    ROUND((wct.wait_class_total_waits / tsw.total_waits) * 100, 2) AS PERCENTAGE_WAIT
FROM
    wait_class_totals wct,
    total_system_waits tsw
ORDER BY
     3 DESC;

--CPU USED BY SPECIFIC PROCESSESS (SUM)/instance
 
 
WITH cpu_stat AS (
    SELECT
        statistic#,
        name
    FROM
        v$statname
    WHERE
        name = 'CPU used by this session'
),
lms_sessions AS (
    SELECT
        s.inst_id,
        s.osuser,
        s.machine,
        ss.value AS cpu_used
    FROM
        gv$sesstat ss
    JOIN
        gv$session s ON ss.sid = s.sid AND ss.inst_id = s.inst_id
    JOIN
        cpu_stat cs ON ss.statistic# = cs.statistic#
    WHERE
        s.program LIKE '%LMS%'
),
total_cpu AS (
    SELECT
        SUM(value) AS total_cpu_used
    FROM
        v$sysstat
    WHERE
        name = 'CPU used by this session'
)
SELECT
    lms.inst_id,
    lms.osuser,
    lms.machine,
    SUM(lms.cpu_used) AS total_cpu_used_by_lms,
    ROUND((SUM(lms.cpu_used) / total.total_cpu_used) * 100, 2) AS lms_cpu_percentage
FROM
    lms_sessions lms,
    total_cpu total
GROUP BY
    lms.inst_id, lms.osuser, lms.machine, total.total_cpu_used
ORDER BY
    lms_cpu_percentage DESC;

--CPU USED BY SPECIFIC PROCESSESS INDIVIDUAL SESSIONS_PER_USER
 
WITH cpu_stat AS (
    SELECT
        statistic#,
        name
    FROM
        v$statname
    WHERE
        name = 'CPU used by this session'
),
lms_sessions AS (
    SELECT
        s.inst_id,
        s.sid,
        s.serial#,
        s.username,
        s.osuser,
        s.machine,
        s.program,
        ss.value AS cpu_used
    FROM
        gv$sesstat ss
    JOIN
        gv$session s ON ss.sid = s.sid AND ss.inst_id = s.inst_id
    JOIN
        cpu_stat cs ON ss.statistic# = cs.statistic#
    WHERE
        s.program LIKE '%LMS%'
)
SELECT
    inst_id,
    sid,
    serial#,
    username,
    osuser,
    machine,
    program,
    cpu_used,
    ROUND((cpu_used / (SELECT SUM(value) FROM v$sysstat WHERE name = 'CPU used by this session')) * 100, 2) AS cpu_percentage
FROM
    lms_sessions
GROUP BY
    inst_id, sid, serial#, username, osuser, machine, program, cpu_used
ORDER BY
    cpu_percentage DESC;
