-- Query to check the Fragmentation of the table.

SELECT 
    owner,
    table_name,
    ROUND((blocks * 8) / (1024 * 1024), 2)  AS "TABLE SIZE GB",
    ROUND((num_rows * avg_row_len) / (1024 * 1024 * 1024), 2)  AS "ACTUAL DATA GB",
    ROUND(100-((ROUND((num_rows * avg_row_len) / (1024 * 1024 * 1024), 2)/ROUND((blocks * 8) / (1024 * 1024), 2))*100),2) as PCT_FRG
FROM 
    dba_tables
WHERE 
    ROUND((blocks * 8) / (1024 * 1024), 2) > 50
    AND TABLESPACE_NAME='XXAPPS_TS_TX_DATA'
ORDER BY 5 DESC;
