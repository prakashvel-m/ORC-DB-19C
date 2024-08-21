select status undo_status,
  round(sum_bytes / (1024*1024), 0) as MB,
  round((sum_bytes / undo_size) * 100, 0) as PERCENTAGE
from
(
  select status, sum(bytes) sum_bytes
  from dba_undo_extents
  group by status
),
(
  select sum(a.bytes) undo_size
  from dba_tablespaces c
    join gv$tablespace b on b.name = c.tablespace_name
    join gv$datafile a on a.ts# = b.ts#
  where c.contents = 'UNDO'
    and c.status = 'ONLINE'
);
