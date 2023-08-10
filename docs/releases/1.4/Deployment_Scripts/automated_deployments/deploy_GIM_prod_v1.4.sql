--WHENEVER SQLERROR EXIT 1
--WHENEVER OSERROR  EXIT 1

DEFINE apps_credentials =&1

CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'deploy_GIM_prod_v1.4_'||TO_CHAR(SYSDATE, 'yyyymmdd') spool_fname FROM DUAL;

SPOOL logs/&spoolname APPEND

SHOW USER;

PROMPT load synonyms for the application
@@"../docs/releases/1.4/Deployment_Scripts/db/create_PRI_GIM_APP_synonyms.sql"

Disconnect;

SPOOL OFF;
