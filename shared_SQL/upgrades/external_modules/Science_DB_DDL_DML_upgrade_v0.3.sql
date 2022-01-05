--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - Scientific Database
--Database Description: DB Module Packager - Scientific Database: This collection of modules is intended to provide functionality for PIFSC scientific databases
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - Scientific Database - version 0.3 updates:
--------------------------------------------------------

--Installed Version 1.1 (Git tag: DVM_db_v1.1) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v1.1.sql

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - Scientific Database', '0.3', TO_DATE('10-AUG-20', 'DD-MON-YY'), 'Upgraded the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git) version from 1.0 to 1.1 (Git tag: DVM_db_v1.1)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
