-- The below query would give the count of data files under each disk group grouped by datafile Size 

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
