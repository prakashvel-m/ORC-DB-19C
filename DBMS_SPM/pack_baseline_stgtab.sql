DECLARE
     my_plans number;
     BEGIN
       my_plans := DBMS_SPM.PACK_STGTAB_BASELINE(
       table_name => 'SPM_STAGETAB',
       enabled => 'yes',
 
 
       table_owner => 'APPS',
       plan_name => 'SQL_PLAN_49sa2mf1smvfzb3d621de',
     sql_handle => 'SQL_44e1429b8389eddf');
   END;
  /
