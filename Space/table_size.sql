SELECT segment_name AS table_name, 
       round(bytes/1024/1024,2) AS size_in_mb 
FROM dba_segments 
WHERE segment_type = 'TABLE' 
AND segment_name like 'FND_LOOKUP_VALUES%'



SELECT 
    o.owner,
    o.object_name,
    e.segment_name,
    o.object_type,
    e.segment_type,
    e.tablespace_name,
    SUM(e.bytes) / (1024 * 1024 * 1024) AS total_size_in_gb
FROM 
    dba_extents e
JOIN 
    dba_objects o
ON 
    e.owner = o.owner AND e.segment_name = o.object_name
WHERE 
    o.object_type = 'TABLE'
    AND o.object_name = 'OE_ORDER_LINES_ALL'
GROUP BY 
    o.owner,
    o.object_name,
    e.segment_name,
    e.segment_type,
    o.object_type,
    e.tablespace_name;
