-- SGA Total vs Used vs Free

SELECT 
    used.inst_id,
    ROUND(used.bytes / (1024 * 1024 * 1024), 2) AS used_gb,
    ROUND(free.bytes / (1024 * 1024 * 1024), 2) AS free_gb,
    ROUND(tot.bytes / (1024 * 1024 * 1024), 2) AS total_gb
FROM 
    (SELECT inst_id, SUM(bytes) AS bytes
     FROM gv$sgastat
     WHERE name != 'free memory'
     GROUP BY inst_id) used,
    (SELECT inst_id, SUM(bytes) AS bytes
     FROM gv$sgastat
     WHERE name = 'free memory'
     GROUP BY inst_id) free,
    (SELECT inst_id, SUM(bytes) AS bytes
     FROM gv$sgastat
     GROUP BY inst_id) tot
WHERE 
    used.inst_id = free.inst_id 
    AND used.inst_id = tot.inst_id;

-- Current SGA Pool and Name Size 

SELECT 
    INST_ID, 
    POOL, 
    NAME, 
    BYTES / (1024 * 1024 * 1024) AS BYTES_GB
FROM 
    GV$SGASTAT 
WHERE 
--NAME LIKE '%DB Replay sess info%' AND
POOL='shared pool'
Order by 1,4 desc;

-- SGA Dynamic Components Current vs Min 

SELECT component, current_size/1024/1024 as size_mb, min_size/1024/1024 as min_size_mb
FROM gv$sga_dynamic_components
WHERE current_size > 0
ORDER BY component;




