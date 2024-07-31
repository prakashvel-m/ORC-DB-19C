SELECT
    MIN(start_time) start_time,
    MAX(end_time) end_time,
    DECODE(event, NULL, 'ON CPU', event) event,
    sql_id,
    SQL_OPNAME,
    COUNT(DISTINCT(sql_id)) sql_cnt,
    SUM(DECODE(session_state, 'ON CPU', 1, 0)) cnt_on_cpu,
    SUM(DECODE(session_state, 'WAITING', 1, 0)) cnt_waiting
FROM (
    SELECT
        FIRST_VALUE(sample_time) OVER(ORDER BY sample_time) start_time,
        LAST_VALUE(sample_time) OVER(
            ORDER BY sample_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) end_time,
        event,
        session_state,
        sql_id,
        SQL_OPNAME
    FROM (
        SELECT *
        FROM GV$ACTIVE_SESSION_HISTORY ash
        WHERE session_id = 3571
        AND session_serial# = 57114
        AND CLIENT_ID='502025410'
    )
)
GROUP BY DECODE(event, NULL, 'ON CPU', event), sql_id,SQL_OPNAME
ORDER BY 3, 2, 4;
