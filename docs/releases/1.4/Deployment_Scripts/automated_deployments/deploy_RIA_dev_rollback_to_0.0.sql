/************************************************************************************
 Filename   : deploy_RIA_dev_rollback_to_0.0.sql
 Author     : Jesse Abdul
 Purpose    : PIFSC Resource Inventory App changes to rollback version 1.4 to 0.0

 Description: The release included reverting changes from the version 0.0 to 1.4 upgrade process

************************************************************************************/
SET FEEDBACK ON
SET TRIMSPOOL ON
SET VERIFY OFF
SET SQLBLANKLINES ON
SET AUTOCOMMIT OFF
SET EXITCOMMIT OFF
SET ECHO ON

WHENEVER SQLERROR EXIT 1
WHENEVER OSERROR  EXIT 1

SET DEFINE ON
-- CAS
DEFINE apps_credentials=&1
CONNECT &apps_credentials


COL spool_fname NEW_VALUE spoolname NOPRINT
SELECT 'RIA_rollback_v1.4_to_v0.0_dev_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;

PROMPT remove synonyms
@@"../docs/releases/1.4/Deployment_Scripts/rollback/drop_PRI_RIA_APP_synonyms.sql"

DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
