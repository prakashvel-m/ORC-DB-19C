-- Count of datafiles for Tablespace across ASM DGs

SELECT 
    REGEXP_SUBSTR(df.file_name, '^\+([^/]+)', 1, 1, NULL, 1) AS disk_group,  -- Extract disk group name
    TO_CHAR(df.bytes / 1024 / 1024 / 1024, 'FM999999999999.00') AS file_size_gb,
    COUNT(df.file_id) AS num_datafiles
FROM 
    dba_data_files df
WHERE 
    df.tablespace_name = 'XXAPPS_TS_TX_DATA'  -- Filter for the specific tablespace
GROUP BY 
    REGEXP_SUBSTR(df.file_name, '^\+([^/]+)', 1, 1, NULL, 1),  -- Group by extracted disk group
    TO_CHAR(df.bytes / 1024 / 1024 / 1024, 'FM999999999999.00')
ORDER BY 
    disk_group, 
    file_size_gb;

-- Count of datafiles for Tablespace across Datafiles grouped by size
SELECT 
    t.tablespace_name,
    COUNT(df.file_id) AS num_datafiles, -- Number of datafiles in the tablespace
    -- Count the number of datafiles grouped by size in GB
    TO_CHAR(df.bytes / 1024 / 1024 / 1024) AS file_size_gb
FROM 
    dba_tablespaces t
LEFT JOIN 
    dba_data_files df
ON 
    t.tablespace_name = df.tablespace_name
WHERE 
    t.tablespace_name IN ('XXAPPS_TS_TX_DATA')  -- Replace with your desired tablespace(s)
GROUP BY 
    t.tablespace_name,t.BIGFILE,TO_CHAR(df.bytes / 1024 / 1024 / 1024)
ORDER BY 
    t.tablespace_name,file_size_gb;
    
