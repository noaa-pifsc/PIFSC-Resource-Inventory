--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - Scientific Database
--Database Description: DB Module Packager - Scientific Database: This collection of modules is intended to provide functionality for PIFSC scientific databases
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - Scientific Database - version 0.5 updates:
--------------------------------------------------------

--Upgraded from Version 1.2 (Git tag: DVM_db_v1.2) to  Version 1.3 (Git tag: DVM_db_v1.3) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v1.3.sql


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - Scientific Database', '0.5', TO_DATE('02-DEC-20', 'DD-MON-YY'), 'Upgraded from Version 1.2 (Git tag: DVM_db_v1.2) to  Version 1.3 (Git tag: DVM_db_v1.3) of the Data Validation Module Database (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/data-validation-module.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
