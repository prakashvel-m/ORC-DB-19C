SELECT
    s.sid,
    s.serial#,
    s.SQL_ID,
    s.username,
    s.client_identifier,
    s.program,
    s.event,
    s.machine,
    s.status,
    l.type,
    l.lmode,
    DECODE(l.lmode,
        0, 'None',
        1, 'Null (N)',
        2, 'Row-S (RS)',
        3, 'Row-X (RX)',
        4, 'Share (S)',
        5, 'S/Row-X (SRX)',
        6, 'Exclusive (X)',
        'Unknown') AS lmode_decoded,
    l.request,
    l.ctime,
    o.object_name
FROM
    gv$lock l
    JOIN gv$session s ON l.sid = s.sid
    JOIN dba_objects o ON l.id1 = o.object_id
WHERE
    o.object_name = 'OE_ORDER_LINES_ALL'
    AND o.object_type = 'TABLE'
ORDER BY
    l.ctime DESC;




select
   c.owner,
   c.object_name,
   c.object_type,
   b.sid,
   b.serial#,
   b.status,
   b.osuser,
   b.machine
from
   gv$locked_object a ,
   gv$session b,
   dba_objects c
where
   b.sid = a.session_id
and
   a.object_id = c.object_id and object_name in ('OBJECT_NAME');




SELECT
    s.inst_id,
    l.sid,
    s.serial#,
    nvl(
        s.username, 'Internal'
    )                 username,
    s.event,
    s.state,
    decode(
        s.command, 0, 'None', decode(
            l.id2, 0, u1.name
                      || '.'
                      || substr(
                t1.name, 1, 20
            ), 'None'
        )
    )                 tab,
    c.command_name    command,
    decode(
        l.lmode, 1, 'No Lock', 2, 'Row Share', 3, 'Row Exclusive', 4, 'Share', 5, 'Share Row Exclusive', 6, 'Exclusive', '--none--'
    )                 lmode,
    decode(
        l.request, 1, 'No Lock', 2, 'Row Share', 3, 'Row Exclusive', 4, 'Share', 5, 'Share Row Exclusive', 6, 'Exclusive', '--none--'
    )                 request,
    l.id1
    || '-'
    || l.id2          laddr,
    l.type
    || ' - '
    || lt.description lockt
FROM
    gv$lock       l,
    gv$session    s,
    sys.user$    u1,
    sys.obj$     t1,
    v$sqlcommand c,
    v$lock_type  lt
WHERE
    l.sid = s.sid
    AND l.inst_id = s.inst_id
    AND t1.obj# = decode(
        l.id2, 0, l.id1, 1
    )
    AND u1.user# = t1.owner#
    AND s.type != 'BACKGROUND'
    AND c.command_type = s.command
    AND lt.type = l.type
ORDER BY
    s.inst_id,
    s.sid;
