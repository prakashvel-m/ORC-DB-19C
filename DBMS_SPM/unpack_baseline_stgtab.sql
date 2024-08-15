DECLARE
  l_plans_unpacked PLS_INTEGER;
BEGIN
  l_plans_unpacked := DBMS_SPM.UNPACK_STGTAB_BASELINE(
    table_name      => 'SPM_STAGETAB',
    table_owner     => 'APPS',
    sql_handle      => 'SQL_44e1429b8389eddf',
    plan_name       => 'SQL_PLAN_49sa2mf1smvfzb3d621de',
    enabled         => 'yes'
  );
 
  DBMS_OUTPUT.PUT_LINE('Plans Unpacked: ' || l_plans_unpacked);
END;
/
