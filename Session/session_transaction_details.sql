-- UNDO TRANSACTION DETAILS


SELECT s.inst_id,s.sid,s.serial#,s.sql_id,ss.PLAN_HASH_VALUE,sp.name as SQL_PROFILE_NAME,sp.last_modified SP_last_modified,
ss.LAST_ACTIVE_TIME,round(ss.elapsed_time/6e+7,0) as elapsed_time,ss.Rows_processed,ss.fetches,t.start_time, t.used_ublk, 
((t.used_ublk*p.value)/1000000000) as UNGO_GB,i.consistent_gets,i.block_gets, i.physical_reads,i.block_changes, i.consistent_changes
FROM gv$session s
LEFT JOIN gv$transaction t ON s.saddr = t.ses_addr
LEFT JOIN gv$sess_io i ON s.sid = i.sid
LEFT JOIN gv$sqlstats ss on ss.sql_id=s.sql_id
LEFT JOIN dba_sql_profiles sp on ss.EXACT_MATCHING_SIGNATURE=sp.SIGNATURE
LEFT JOIN gv$parameter p on p.NAME='db_block_size'
WHERE s.inst_id=i.inst_id and s.inst_id=ss.inst_id and
s.sid = 3843 and s.serial#=64404;

-- UNDO TRANSACTION DETAILS ALONG WITH DETAILS OF OBJECTS BEING ACCESSED

SELECT distinct s.inst_id,s.sql_id,s.SQL_EXEC_START,sp1.object_owner,sp1.object_name,ss.PLAN_HASH_VALUE,sp.name as SQL_PROFILE_NAME,sp.last_modified SP_last_modified,s.sid, s.serial#,ss.LAST_ACTIVE_TIME,round(ss.elapsed_time/6e+7,0) as elapsed_time,ss.Rows_processed,ss.fetches,t.start_time, t.used_ublk, i.consistent_gets,i.block_gets, i.physical_reads, i.block_changes, i.consistent_changes
FROM dba_objects do,gv$sql_plan sp1,gv$session s
LEFT JOIN gv$transaction t ON s.saddr = t.ses_addr
LEFT JOIN gv$sess_io i ON s.sid = i.sid
LEFT JOIN gv$sqlstats ss on ss.sql_id=s.sql_id
LEFT JOIN dba_sql_profiles sp on ss.EXACT_MATCHING_SIGNATURE=sp.SIGNATURE
WHERE s.inst_id=i.inst_id and s.inst_id=ss.inst_id and ss.LAST_ACTIVE_CHILD_ADDRESS = sp1.CHILD_ADDRESS
and sp1.object_owner = do.owner AND sp1.object_name = do.object_name and 
OBJECT_OWNER is not null and s.SQL_CHILD_NUMBER = sp1.CHILD_NUMBER and
s.sid = 312 and s.serial#=17292;


-- UNDO TRANSACTION DETAILS ALONG WITH DETAILS OF OBJECTS BEING ACCESSED AND THEIR STATS

SELECT distinct s.inst_id,s.sql_id,s.SQL_EXEC_START,sp1.object_owner,sp1.object_name,os.stale_stats,os.LAST_ANALYZED,ss.PLAN_HASH_VALUE,sp.name as SQL_PROFILE_NAME,sp.last_modified SP_last_modified,s.sid, s.serial#,ss.LAST_ACTIVE_TIME,round(ss.elapsed_time/6e+7,0) as elapsed_time,ss.Rows_processed,ss.fetches,t.start_time, t.used_ublk, i.consistent_gets,i.block_gets, i.physical_reads, i.block_changes, i.consistent_changes
FROM dba_tab_statistics os,dba_objects do,gv$sql_plan sp1,gv$session s
LEFT JOIN gv$transaction t ON s.saddr = t.ses_addr
LEFT JOIN gv$sess_io i ON s.sid = i.sid
LEFT JOIN gv$sqlstats ss on ss.sql_id=s.sql_id
LEFT JOIN dba_sql_profiles sp on ss.EXACT_MATCHING_SIGNATURE=sp.SIGNATURE
WHERE s.inst_id=i.inst_id and s.inst_id=ss.inst_id and ss.LAST_ACTIVE_CHILD_ADDRESS = sp1.CHILD_ADDRESS
and sp1.object_owner = do.owner AND sp1.object_name = do.object_name and do.object_name=os.table_name and
OBJECT_OWNER is not null and s.SQL_CHILD_NUMBER = sp1.CHILD_NUMBER and do.object_type in ('TABLE','VIEW') and
s.sid = 2313 and s.serial#=9112;
