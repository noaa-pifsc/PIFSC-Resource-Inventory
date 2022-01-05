--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - Scientific Database
--Database Description: DB Module Packager - Scientific Database: This collection of modules is intended to provide functionality for PIFSC scientific databases
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - Scientific Database - version 0.2 updates:
--------------------------------------------------------

--Installed Version 0.2 (Git tag: db_log_db_v0.2) of the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git)
@@upgrades/external_modules/DB_log_DDL_DML_upgrade_v0.2.sql


--Installed Version 1.0 (Git tag: DVM_db_v1.0) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)

@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.1.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.2.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.3.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.4.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.5.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.6.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.7.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.8.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.9.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.10.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.11.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.12.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v0.13.sql
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v1.0.sql

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - Scientific Database', '0.2', TO_DATE('05-AUG-20', 'DD-MON-YY'), 'Upgraded the Database Logging Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/database-logging-module.git) from version 0.1 to 0.2 (Git tag: db_log_db_v0.2).  Installed Version 1.0 (Git tag: DVM_db_v1.0) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
