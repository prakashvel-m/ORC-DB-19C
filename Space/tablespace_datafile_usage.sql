-- Space used by Tablespace across Datafiles grouped by size

SELECT 
    t.tablespace_name,
    COUNT(df.file_id) AS num_datafiles,
    TO_CHAR(df.bytes / 1024 / 1024 / 1024, 'FM999999999999.00') AS file_size_gb,
    ROUND(SUM(df.bytes - NVL(f.free_bytes, 0)) / 1024 / 1024 / 1024, 2) AS space_used_gb,
    ROUND(SUM(NVL(f.free_bytes, 0)) / 1024 / 1024 / 1024, 2) AS space_free_gb
FROM 
    dba_tablespaces t
LEFT JOIN 
    dba_data_files df ON t.tablespace_name = df.tablespace_name
LEFT JOIN 
    (
        SELECT 
            tablespace_name, 
            file_id, 
            SUM(bytes) AS free_bytes
        FROM 
            dba_free_space
        GROUP BY 
            tablespace_name, 
            file_id
    ) f ON df.tablespace_name = f.tablespace_name AND df.file_id = f.file_id
WHERE 
    t.tablespace_name IN ('XXAPPS_TS_TX_DATA')  -- Replace with your desired tablespace(s)
GROUP BY 
    t.tablespace_name, 
    TO_CHAR(df.bytes / 1024 / 1024 / 1024, 'FM999999999999.00')
ORDER BY 
    t.tablespace_name, 
    file_size_gb;
