
-- 1) Select the current settings of parameters from the database.


SELECT name, value
  FROM v$parameter
 WHERE name in ('db_cache_size', 'large_pool_size', 'java_pool_size',
                'shared_pool_size', 'streams_pool_size', 'sga_target', 
                'sga_max_size', 'statistics_level')

NAME                                     VALUE
------------------------------ ---------------
sga_max_size                         314572800
sga_target                           314572800
statistics_level                       TYPICAL
shared_pool_size                             0
large_pool_size                              0
java_pool_size                               0
streams_pool_size                            0
db_cache_size                                0

SQL> show parameter db_recycle_cache_size

NAME                                              VALUE
------------------------------------ -----------------
db_recycle_cache_size                                0


-- 2) Given the information above, determine the current actual size of the parameters by implementing the following query:

SELECT name, bytes 
  FROM v$sgainfo;

NAME                                      BYTES
--------------------------------    -----------
Fixed SGA Size                          1261516
Redo Buffers                            7127040
Buffer Cache Size                     188743680 *
Shared Pool Size                      109051904 *
Large Pool Size                         4194304 *
Java Pool Size                          4194304 *
Streams Pool Size                             0
Granule Size                            4194304
Maximum SGA Size                      314572800 **
Startup overhead in Shared Pool        37748736
Free SGA Memory Available                     0

-- NOTE:
-- * Even though db_cache_size, shared_pool_size, large_pool_size and java_pool_size were set to zero as initialization parameters,
--   their current values have been automatically modified based on database activity requirements needed for these memory components.
--   In this example, streams_pool_size has not been used and remains at a size of zero.

-- ** Maximum SGA Size = sga_max_size (300 * 1024 *1024)   


-- 3) Notice the changes that occur when a manually tuned parameter like  DB_RECYLE_CACHE_SIZE is set:

SQL> show parameter db_recycle_cache_size

NAME                                        VALUE
------------------------------------   ----------
db_recycle_cache_size                         12M


SELECT component, current_size 
  FROM v$sga_dynamic_components;

COMPONENT                                          CURRENT_SIZE
----------------------------------         --------------------
shared pool                                           109051904
large pool                                              4194304
java pool                                               4194304
streams pool                                                  0
DEFAULT buffer cache                                  176160768 *
KEEP buffer cache                                             0
RECYCLE buffer cache                                   12582912 *
DEFAULT 2K buffer cache                                       0
DEFAULT 4K buffer cache                                       0
DEFAULT 8K buffer cache                                       0
DEFAULT 16K buffer cache                                      0
DEFAULT 32K buffer cache                                      0
ASM Buffer Cache                                              0

-- * Memory was automatically adjusted to account for setting of manually tuned parameter.
--   The original value of DB_CACHE_SIZE was 188743680.  It has been reduced to accommodate the value set for db_recycle_cache_size.

 
/*
Scenarios to consider when using ASMM and when manually changing memory parameters:

If an autotuned parameter is increased in size above its minimum value, then the associated SGA component is immediately changed.  Memory used in this case is taken away from one or more autotuned components; manually tuned components are not affected.
If an autotuned parameter is decreased below it's minimum value, the parameter is not immediately changed.  MMAN's automatic memory-tuning algorithm will later reduce the parameter as required.
If a manually tuned parameter is increased, the change will take effect immediately.  The memory will be taken away from one or more of the automatically sized components.
If a manually tuned parameter is decreased, the change will take effect immediately.  The memory will be added to the automatically sized components. 
 */

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
