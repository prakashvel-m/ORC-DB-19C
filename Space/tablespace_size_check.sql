SELECT m.tablespace_name, ROUND(m.used_percent, 2) percent_used, ROUND((m.tablespace_size - m.used_space)*t.block_size/1024/1024/1024, 3) gb_free
FROM dba_tablespace_usage_metrics m, dba_tablespaces t
WHERE t.contents NOT IN ('TEMPORARY', 'UNDO') AND t.tablespace_name = m.tablespace_name
order by 2 desc;
 
 
SELECT m.tablespace_name, ROUND(m.used_percent, 2) percent_used
FROM dba_tablespace_usage_metrics m, dba_tablespaces t
WHERE t.contents NOT IN ('TEMPORARY', 'UNDO') AND t.tablespace_name = m.tablespace_name
order by 2 desc;
