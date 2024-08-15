DECLARE
    ret               BINARY_INTEGER;
    l_sql_id          VARCHAR2(13);
    l_plan_hash_value NUMBER;
    l_fixed           VARCHAR2(3);
    l_enabled         VARCHAR2(3);
    l_sql_handle      VARCHAR2(20);
BEGIN
    l_sql_id          := 'xxxxxxxxx';
    l_plan_hash_value := TO_NUMBER ( '999999999999' );
    l_fixed           := 'Yes';
    l_enabled         := 'Yes';
    l_sql_handle      := 'xxxxxxxxxxxxxxx';
    ret := dbms_spm.load_plans_from_cursor_cache(
	       sql_id          => l_sql_id, 
		   plan_hash_value => l_plan_hash_value, 
		   fixed           => l_fixed, 
		   enabled         => l_enabled,
		   sql_handle      => l_sql_handle);
 
END;    
/
