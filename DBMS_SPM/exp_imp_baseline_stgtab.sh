
#Export command to export basleine from staging table to a dump file
exp system@oradb file=SPM_STAGETAB_baseline.dmp tables=APPS.SPM_STAGETAB log=SPM_STAGETAB_baseline.log parfile=query.par compress=n statistics=none

#use this as the par file to filter the required baseline 
query="where SIGNATURE =4963321500033215967 and PLAN_ID=3017155038"

#Import command to import basleine from dump file to staging table
imp system@oradb file=SPM_STAGETAB_baseline.dmp log=SPM_STAGETAB_baseline.log fromuser=apps touser=apps statistics=none ignore=y
