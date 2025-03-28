WITH SGA_STATS AS (
    SELECT 
        sgs.instance_number,
        sgs.snap_id,
        sn.begin_interval_time,
        sn.end_interval_time,
        sgs.name,
        ROUND(sgs.bytes / 1024 / 1024, 2) AS mb
    FROM 
        dba_hist_sgastat sgs
    JOIN 
        dba_hist_snapshot sn ON sgs.snap_id = sn.snap_id AND sgs.instance_number = sn.instance_number
    WHERE 
        sgs.name = 'DB Replay sess info'
        AND sn.begin_interval_time >= TO_DATE('2025-03-19', 'YYYY-MM-DD')
        AND sgs.instance_number = 1
),
SGA_STATS_WITH_PREV AS (
    SELECT 
        sga.instance_number,
        sga.snap_id,
        sga.begin_interval_time,
        sga.end_interval_time,
        sga.name,
        sga.mb,
        COALESCE(LAG(sga.mb) OVER (PARTITION BY sga.instance_number ORDER BY sga.snap_id), 0) AS prev_mb
    FROM 
        SGA_STATS sga
),
GROWTH_RATES AS (
    SELECT 
        instance_number,
        snap_id,
        begin_interval_time,
        end_interval_time,
        name,
        mb,
        CASE 
            WHEN prev_mb = 0 THEN 0
            ELSE ROUND((mb - prev_mb), 2)
        END AS growth_rate_mb_per_30min
    FROM 
        SGA_STATS_WITH_PREV
)
SELECT 
    (SELECT mb FROM GROWTH_RATES ORDER BY snap_id DESC FETCH FIRST 1 ROW ONLY) AS current_size_mb,
    (SELECT AVG(growth_rate_mb_per_30min) FROM GROWTH_RATES WHERE growth_rate_mb_per_30min > 0) AS avg_growth_rate_mb_per_30min,
    CEIL((:X_GB - (SELECT mb FROM GROWTH_RATES ORDER BY snap_id DESC FETCH FIRST 1 ROW ONLY)) / (SELECT AVG(growth_rate_mb_per_30min) FROM GROWTH_RATES WHERE growth_rate_mb_per_30min > 0)) AS required_intervals,
    (SELECT MAX(end_interval_time) FROM GROWTH_RATES) + INTERVAL '30' MINUTE * CEIL((:X_GB - (SELECT mb FROM GROWTH_RATES ORDER BY snap_id DESC FETCH FIRST 1 ROW ONLY)) / (SELECT AVG(growth_rate_mb_per_30min) FROM GROWTH_RATES WHERE growth_rate_mb_per_30min > 0)) AS estimated_reach_date
FROM 
    DUAL;
