SELECT 
    owner AS schema_name,
    ROUND(SUM(bytes) / 1024 / 1024 / 1024, 2) AS space_used_gb
FROM 
    dba_segments
WHERE 
    tablespace_name = 'XXAPPS_TS_TX_DATA'  -- Specify your desired tablespace here
GROUP BY 
    owner
ORDER BY 
    space_used_gb DESC;
    
    
WITH tablespace_total AS (
    SELECT 
        tablespace_name, 
        SUM(bytes) AS total_bytes
    FROM 
        dba_segments
    WHERE 
        tablespace_name = 'XXAPPS_TS_TX_DATA'
    GROUP BY 
        tablespace_name
)
SELECT 
    ds.owner AS schema_name,
    ROUND(SUM(ds.bytes) / 1024 / 1024 / 1024, 2) AS space_used_gb,
    ROUND((SUM(ds.bytes) / t.total_bytes) * 100, 2) AS pct_of_tablespace
FROM 
    dba_segments ds
JOIN 
    tablespace_total t ON ds.tablespace_name = t.tablespace_name
WHERE 
    ds.tablespace_name = 'XXAPPS_TS_TX_DATA'
GROUP BY 
    ds.owner, 
    t.total_bytes
ORDER BY 
    space_used_gb DESC;   
