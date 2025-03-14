WITH Recent_SGA_Stats AS (
    SELECT
        s.snap_id,
        sn.begin_interval_time,
        s.instance_number,
        s.pool,
        s.name,
        MAX(s.bytes) AS max_bytes
    FROM
        dba_hist_sgastat s
    JOIN
        dba_hist_snapshot sn ON s.snap_id = sn.snap_id AND s.dbid = sn.dbid
    WHERE
        sn.begin_interval_time >= SYSDATE - INTERVAL '5' HOUR
        --AND s.pool='shared pool'
    GROUP BY
        s.snap_id, sn.begin_interval_time, s.instance_number, s.pool, s.name
),
Ranked_SGA_Stats AS (
    SELECT
        instance_number,
        name,
        pool,
        ROUND(max_bytes / (1024 * 1024 * 1024), 2) AS max_bytes_gb,
        ROW_NUMBER() OVER (PARTITION BY instance_number ORDER BY max_bytes DESC) AS rn
    FROM
        Recent_SGA_Stats
)
SELECT
    instance_number,
    name,
    pool,
    max_bytes_gb
FROM
    Ranked_SGA_Stats
WHERE
    rn <= 10
ORDER BY
    instance_number, max_bytes_gb DESC;
