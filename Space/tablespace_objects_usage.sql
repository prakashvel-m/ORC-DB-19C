-- Top Objects Under a tablespace ( Greater than 50G )

SELECT owner,
         segment_name,
         segment_type,
         tablespace_name,
         ROUND (SUM (bytes) / (1024 * 1024 * 1024), 2)     AS size_gb
    FROM dba_segments
   WHERE segment_type IN ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION')
   and tablespace_name='XXAPPS_TS_TX_DATA'
GROUP BY owner, segment_name,segment_type,tablespace_name
  HAVING SUM (bytes) > 50 * 1024 * 1024 * 1024
ORDER BY size_gb DESC; 


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
    ds.owner,
    ds.segment_name,
    ds.segment_type,
    ds.tablespace_name,
    ROUND(SUM(ds.bytes) / (1024 * 1024 * 1024), 2) AS size_gb,
    ROUND((SUM(ds.bytes) / t.total_bytes) * 100, 2) AS pct_of_tablespace
FROM 
    dba_segments ds
JOIN 
    tablespace_total t ON ds.tablespace_name = t.tablespace_name
WHERE 
    ds.segment_type IN ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION')
    AND ds.tablespace_name = 'XXAPPS_TS_TX_DATA'
GROUP BY 
    ds.owner, 
    ds.segment_name, 
    ds.segment_type, 
    ds.tablespace_name, 
    t.total_bytes
HAVING 
    SUM(ds.bytes) > 50 * 1024 * 1024 * 1024
ORDER BY 
    size_gb DESC;
