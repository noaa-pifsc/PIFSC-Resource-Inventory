/************************************************************************************
 Filename   : deploy_qa_v1.0.sql
 Author     : Jesse Abdul
 Purpose    : PIFSC Resource Inventory db changes for version 1.0

 Description: The release included: initial data model deployment for version 1.0 of the DB

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
SELECT 'PRI_DB_deploy_qa_v1.0_' || TO_CHAR( SYSDATE, 'yyyymmdd' ) spool_fname FROM DUAL;
SPOOL logs/&spoolname APPEND


SET DEFINE OFF
SHOW USER;

PROMPT running DDL scripts
@@upgrades/pifsc_resource_inventory_DDL_DML_upgrade_v0.1.sql
@@upgrades/pifsc_resource_inventory_DDL_DML_upgrade_v0.2.sql
@@upgrades/pifsc_resource_inventory_DDL_DML_upgrade_v0.3.sql
@@upgrades/pifsc_resource_inventory_DDL_DML_upgrade_v0.4.sql
@@upgrades/pifsc_resource_inventory_DDL_DML_upgrade_v0.5.sql
@@upgrades/pifsc_resource_inventory_DDL_DML_upgrade_v1.0.sql


PROMPT granting privileges to application schemas
@@"../docs/releases/1.4/Deployment_Scripts/db/grant_PRI_GIM_APP_privs.sql"
@@"../docs/releases/1.4/Deployment_Scripts/db/grant_PRI_RIA_APP_privs.sql"

PROMPT loading data
@@"../docs/releases/1.4/Deployment_Scripts/db/load_ref_data.sql"

DISCONNECT;

SET DEFINE ON

SPOOL OFF
EXIT
