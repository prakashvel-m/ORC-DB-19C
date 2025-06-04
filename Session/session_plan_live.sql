SELECT  m.sql_id              ,
        m.sql_plan_hash_value ,
        p.id                  ,
        rpad(' ',p.depth*2, ' ')
        ||
        p.operation
        ||
        '   '
        ||
        p.options operation        ,
        p.object_name object       ,
        p.cardinality card         ,
        p.cost cost                ,
        SUBSTR(m.status,1,4) status,
        m.output_rows
FROM    gv$sql_plan p         ,
        gv$sql_plan_monitor m ,
        gv$sql_monitor s
WHERE   p.sql_id                 =m.sql_id
        AND p.child_address      =m.sql_child_address
        AND p.plan_hash_value    =m.sql_plan_hash_value
        AND p.id                 =m.plan_line_id
        AND s.sid                = 181
        AND s.inst_id            = 3
        AND SUBSTR(m.status,1,4) = 'EXEC'
        AND s.inst_id            = m.inst_id
        AND s.inst_id            = p.inst_id
        AND s.key                = m.key
ORDER BY id;
