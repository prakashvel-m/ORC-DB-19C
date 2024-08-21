SELECT
    e.tablespace_name,
    e.file_id,
    df.file_name,
    df.autoextensible,
    COUNT(e.extent_id) AS num_extents,
    s.segment_name,
    s.segment_type,
    s.min_extents,
    s.max_extents
FROM
    dba_extents e
JOIN
    dba_segments s ON e.segment_name = s.segment_name AND e.owner = s.owner
JOIN
    dba_data_files df ON e.file_id = df.file_id
WHERE
    e.tablespace_name = 'APPS_UNDOTS2' -- Replace with your tablespace name
GROUP BY
    e.tablespace_name,
    e.file_id,
    df.file_name,
    df.autoextensible,
    s.segment_name,
    s.segment_type,
    s.min_extents,
    s.max_extents
ORDER BY
    e.file_id,
    s.segment_name;
