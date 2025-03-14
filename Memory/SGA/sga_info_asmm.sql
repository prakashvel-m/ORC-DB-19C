/*Automatic Shared Memory Management (ASMM) is a feature of the Oracle database 10g that automates the management of the following shared memory structures:  DB_CACHE_SIZE, SHARED_POOL_SIZE, LARGE_POOL_SIZE, JAVA_POOL_SIZE, and STREAMS_POOL_SIZE (in 10.2 and beyond).

NOTE:
ASSM as described is still available in Oracle 11g but has been further developed to Automatic Memory Management (AMM). AMM also takes PGA memory into account for automatic tuning.

When implemented, ASMM will enable the Oracle database to distribute memory between these components based on workload requirements.  Hence, these components are considered autotuned parameters. The background process, Memory Manager (MMAN), coordinates the sizing of these components and moves memory to where it is needed most.

To implement this feature, the following initialization parameters must be set:

SGA_TARGET set to a nonzero value
STATISTICS_LEVEL=TYPICAL (or ALL)
 

NOTE:
SGA_TARGET is a dynamic parameter and be changed with the ALTER SYSTEM command.  It can be increased up to the value of the SGA_MAX_SIZE or reduced until any one of the autotuned parameters reaches its minimum size.  SGA_MAX_SIZE is the maximum amount of memory that can be allocated to the SGA.
When these values are not set, ASMM is disabled and the autotuned parameters must be configured manually. When ASMM is implemented, the default value of the autotuned parameters is zero unless a value has been set.  If a value is specified, it will be used as a minimum size.

The Fixed SGA and the following components are not considered autotuned parameters and are not a part of the ASMM feature. These are considered manually tuned memory parameters: LOG_BUFFER, DB_KEEP_CACHE_SIZE, DB_RECYCLE_CACHE_SIZE, DB_nK_CACHE_SIZE, and STREAMS_POOL_SIZE (in 10.1).

When the SGA_TARGET is set, the total size for these manually tuned parameters is subtracted from SGA_TARGET and the balance remaining is available for the autotuned SGA components. 

*/


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
