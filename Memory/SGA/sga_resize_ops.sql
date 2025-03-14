-- The following queries may be helpful when monitoring manually and autotuned components:

set line 190
col component for a25
col status format a10 head "Status"
col initial_size for 999,999,999,999 head "Initial"
col parameter for a25 heading "Parameter"
col final_size for 999,999,999,999 head "Final"
col changed head "Changed At"
col low format 999,999,999,999 head "Lowest"
col high format 999,999,999,999 head "Highest"
col lowMB format 999,999 head "MBytes"
col highMB format 999,999 head "MBytes"

SELECT component, parameter, initial_size, final_size, status, 
               to_char(end_time ,'mm/dd/yyyy hh24:mi:ss') changed
FROM    v$sga_resize_ops
ORDER BY component;

SELECT component, min(final_size) low, (min(final_size/1024/1024)) lowMB,
               max(final_size) high, (max(final_size/1024/1024)) highMB
FROM   v$sga_resize_ops
GROUP BY component
ORDER BY component;


SELECT 
    component, 
    parameter, 
    initial_size/1024/1024 as init_mb, 
    final_size/1024/1024 as final_mb, 
    status,
    CASE 
        WHEN final_size > initial_size THEN 'Increase ↑'
        WHEN final_size < initial_size THEN 'Decrease ↓'
        ELSE 'No Change'
    END AS Summary, 
    end_time,
    sysdate AS current_time
    
FROM 
    gv$sga_resize_ops
ORDER BY 
    end_time DESC;
