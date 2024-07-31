-- CHECK TOTAL FRA DETAILS
 
SELECT 
   ROUND((SPACE_LIMIT / 1024 / 1024 / 1024),2) "Size (GB)",
   ROUND((SPACE_USED / 1024 / 1024 / 1024),2) "Used (GB)",
   ROUND((SPACE_RECLAIMABLE / 1024 / 1024 / 1024),2) "Reclaimable (GB)",
   NUMBER_OF_FILES "Files"
FROM V$RECOVERY_FILE_DEST;
 
-- CHECK FRA INDIVIDUAL SPECIFIC DETAILS
 
 
SELECT
    a.file_type,
    a.percent_space_used,
    round((a.percent_space_used *(b.space_limit / 1024 / 1024 / 1024) / 100), 2) gb,
    a.number_of_files
FROM
    v$flash_recovery_area_usage a,
    v$recovery_file_dest        b
ORDER BY
    3 DESC;
 
-- DATABASE PARAMETERS
 
select * from gv$parameter where name ='db_recovery_file_dest_size';
 
select * from v$restore_point;
 
-- ASM DISK GROUP STATUS
 
SELECT 
    name, 
    total_mb/1048576 AS total_tb, 
    free_mb/1048576 AS free_tb, 
    usable_file_mb/1048576 AS usable_file_tb,
    round(((usable_file_mb)/1048576),2) AS usable_file_in_TB, 
    round(((total_mb-nvl(free_mb,0))/total_mb)*100,0) AS PERCENT  
FROM 
    V$ASM_DISKGROUP_STAT;
 
-- ARCHIVE DEST DETAILS
 
select dest_id,dest_name,target,ARCHIVER,DESTINATION,DB_UNIQUE_NAME,error,status,log_sequence,applied_scn 
from v$archive_dest where dest_id in (1,2,3,4,5,6,7,8);
 
select * from v$archive_dest WHERE STATUS='VALID';
 
 
select * from V$MANAGED_STANDBY;
 
select * from v$database_incarnation;
 
 
select * from v$archive_dest_status WHERE STATUS='VALID';
