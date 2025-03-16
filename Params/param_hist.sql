SELECT 
    param.snap_id,
    snap.begin_interval_time AS snapshot_time,
    param.instance_number,
    param.parameter_name,
    param.value,
    param.isdefault,
    param.ismodified
FROM 
    dba_hist_parameter param
JOIN 
    dba_hist_snapshot snap ON param.snap_id = snap.snap_id AND param.dbid = snap.dbid
WHERE 
    param.parameter_name = 'recyclebin' and value <> 'on'
ORDER BY 
    snap.begin_interval_time asc;
