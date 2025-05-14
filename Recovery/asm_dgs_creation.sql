SELECT 'CREATE DISKGROUP ' || dg.name || ' ' ||
       dg.type || ' REDUNDANCY ' ||
       'DISK ' ||
       LISTAGG(''''||d.path||'''', ',') WITHIN GROUP (ORDER BY d.path) || ' ' ||
       'ATTRIBUTE ' ||
       '''COMPATIBLE.ASM''=''' || dg.compatibility || ''', ' ||
       '''COMPATIBLE.RDBMS''=''' || dg.database_compatibility || ''', ' ||
       '''AU_SIZE''=''' || dg.allocation_unit_size || ''';'
FROM v$asm_diskgroup dg
JOIN v$asm_disk d
  ON dg.group_number = d.group_number
WHERE d.name IS NOT NULL -- Exclude disks with no name
GROUP BY dg.name, dg.type, dg.compatibility, dg.database_compatibility, dg.allocation_unit_size;
