--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - Scientific Database
--Database Description: DB Module Packager - Scientific Database: This collection of modules is intended to provide functionality for PIFSC scientific databases
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - Scientific Database - version 0.1 updates:
--------------------------------------------------------


--Installing version 0.2 of Database Version Control (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-version-control-module.git)--
@@upgrades/external_modules/DB_version_control_DDL_DML_upgrade_v0.1.sql
@@upgrades/external_modules/DB_version_control_DDL_DML_upgrade_v0.2.sql


--Installed Version 0.1 of the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git)
@@upgrades/external_modules/DB_log_DDL_DML_upgrade_v0.1.sql

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - Scientific Database', '0.1', TO_DATE('01-JUN-20', 'DD-MON-YY'), 'Installed version 0.2 of Database Version Control (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-version-control-module.git).  Installed Version 0.1 of the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
