-- This query gives a overall overview of the RAC Setup 

SELECT DISTINCT
    pdb.inst_id,
    cdb.DB_UNIQUE_NAME,
    cdb.NAME AS CDB_NAME,
    inst.INSTANCE_NAME,
    pdb.name AS PDB_NAME,
    cdb.OPEN_MODE AS CDB_OPEN_MODE,
    pdb.OPEN_MODE AS PDB_OPEN_MODE,
    inst.HOST_NAME,
    inst.VERSION_FULL,
    inst.DATABASE_TYPE,
    cdb.CREATED AS CDB_CREATED,
    pdb.CREATION_TIME AS PDB_CREATED,
    cdb.LOG_MODE,
    ROUND(pdb.total_size / 1024 / 1024 / 1024 / 1024, 2) AS PDB_SIZE_TB,
    CASE
        WHEN inst.DATABASE_TYPE = 'RAC' AND srv.SESSION_STATE_CONSISTENCY = 'DYNAMIC' THEN srv.name
        ELSE NULL
    END AS SERVICE_NAME,
    CASE
        WHEN inst.DATABASE_TYPE = 'RAC' AND srv.SESSION_STATE_CONSISTENCY = 'DYNAMIC' THEN srv.network_name
        ELSE NULL
    END AS NETWORK_NAME,
    CASE
        WHEN inst.DATABASE_TYPE = 'RAC' AND srv.SESSION_STATE_CONSISTENCY = 'DYNAMIC' THEN srv.SESSION_STATE_CONSISTENCY
        ELSE NULL
    END AS SESSION_STATE_CONSISTENCY,
    sga.display_value AS SGA_MAX_SIZE,
    pga.display_value AS PGA_AGGREGATE_TARGET
FROM 
    gv$database cdb
    JOIN gv$pdbs pdb ON pdb.DBID = cdb.CON_DBID AND pdb.inst_id = cdb.inst_id
    JOIN gv$instance inst ON cdb.inst_id = inst.inst_id
    LEFT JOIN gv$services srv ON inst.inst_id = srv.inst_id AND inst.DATABASE_TYPE = 'RAC' AND srv.SESSION_STATE_CONSISTENCY = 'DYNAMIC'
    LEFT JOIN gv$parameter sga ON sga.name = 'sga_max_size'
    LEFT JOIN gv$parameter pga ON pga.name = 'pga_aggregate_target'
WHERE
    inst.DATABASE_TYPE = 'RAC' OR inst.DATABASE_TYPE IS NOT NULL
ORDER BY 
    pdb.inst_id ASC;
