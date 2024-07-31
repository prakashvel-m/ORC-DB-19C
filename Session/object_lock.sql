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
