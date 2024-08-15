DECLARE
    l_plans_loaded PLS_INTEGER;
BEGIN
    l_plans_loaded := DBMS_SPM.LOAD_PLANS_FROM_AWR(
        begin_snap    => 12345,
        end_snap      => 12346,
        basic_filter  => 'sql_id = ''xxxxxxxxx'' AND plan_hash_value = xxxxxxxxxxxxxx',
        fixed         => 'YES',
        enabled       => 'YES',
        commit_rows   => 1000
    );
    DBMS_OUTPUT.PUT_LINE('Number of plans loaded: ' || l_plans_loaded);
END;
/
