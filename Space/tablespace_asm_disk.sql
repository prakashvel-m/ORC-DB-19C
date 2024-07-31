SELECT d.tablespace_name, g.name AS disk_group
FROM v$asm_alias a, v$asm_file f, v$asm_diskgroup g, dba_data_files d
WHERE a.file_number = f.file_number
AND f.group_number = g.group_number
AND d.file_id = a.file_number
AND d.tablespace_name = 'tablespace_name';
