SELECT 
    df.file_id,
    df.file_name,
    df.tablespace_name,
    df.bytes / (1024 * 1024) AS size_mb,
    df.autoextensible,
    df.maxbytes / (1024 * 1024) AS max_size_mb,
    df.status,
    df.online_status,
    vf.status AS vfile_status,
    vf.enabled AS vfile_enabled
FROM 
    dba_data_files df
JOIN 
    gv$datafile vf ON df.file_id = vf.file#
JOIN 
    gv$tablespace vt ON df.tablespace_name = vt.name
WHERE 
    df.tablespace_name = 'APPS_UNDOTS2';
