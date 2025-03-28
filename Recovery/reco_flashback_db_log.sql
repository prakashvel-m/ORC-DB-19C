-- DETAILS ABOUT FLASHBACK DATABASE LOG FILES


SELECT 
  fdl.inst_id,
  ROUND(((MAX(fdl.FIRST_TIME)) - (MIN(fdl.FIRST_TIME))) * 24, 2) AS CRR_FILE_HRS,
  p.value / 60 AS RETN_HR,
  COUNT(*) AS TOTAL_FILES,
  SUM(CASE WHEN fdl.TYPE = 'RESERVED' THEN 1 ELSE 0 END) AS RESERVED_FILES,
  SUM(CASE WHEN fdl.TYPE = 'NORMAL' THEN 1 ELSE 0 END) AS NORMAL_FILES
FROM 
  gv$flashback_database_logfile fdl
JOIN 
  gv$parameter p ON fdl.inst_id = p.inst_id AND p.name = 'db_flashback_retention_target'
GROUP BY 
  fdl.inst_id, p.value
ORDER BY 
  INST_ID, CRR_FILE_HRS ASC;
