--WHENEVER SQLERROR EXIT 1
--WHENEVER OSERROR  EXIT 1

DEFINE apps_credentials =&1

CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'PRI_deploy_RIA_qa_'||TO_CHAR(SYSDATE, 'yyyymmdd') spool_fname FROM DUAL;

SPOOL logs/&spoolname APPEND

SHOW USER;

PROMPT load synonyms for the RIA application
@@../RIA/SQL/create_PRI_RIA_APP_synonyms.sql

Disconnect;

SPOOL OFF;
