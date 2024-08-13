-- query to check the index and partition index sizes

SELECT 
    s.segment_type,
    s.segment_name,
    s.tablespace_name,
    SUM(s.bytes) / (1024 * 1024 * 1024) AS size_in_gb
FROM 
    dba_segments s
WHERE 
    s.owner = '&&OWNER'
    AND s.segment_type IN ('INDEX', 'INDEX PARTITION')
    AND s.segment_name IN (
        SELECT index_name 
        FROM dba_indexes 
        WHERE table_owner = '&OWNER' 
        AND table_name = '&&TABLE_NAME'
        UNION
        SELECT partition_name 
        FROM dba_ind_partitions 
        WHERE index_owner = '&OWNER' 
        AND index_name IN (
            SELECT index_name 
            FROM dba_indexes 
            WHERE table_owner = '&OWNER' 
            AND table_name = '&&TABLE_NAME'
        )
    )
GROUP BY 
    s.segment_type,
    s.segment_name,
    s.tablespace_name;
