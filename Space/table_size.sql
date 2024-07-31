SELECT segment_name AS table_name, 
       round(bytes/1024/1024,2) AS size_in_mb 
FROM dba_segments 
WHERE segment_type = 'TABLE' 
AND segment_name like 'FND_LOOKUP_VALUES%'
