--------------------------------------------------------
--------------------------------------------------------
--Database Name: DB Module Packager - Scientific Database
--Database Description: DB Module Packager - Scientific Database: This collection of modules is intended to provide functionality for PIFSC scientific databases
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--DB Module Packager - Scientific Database - version 1.0 updates:
--------------------------------------------------------

--Upgraded from Version 0.2 (Git tag: db_log_db_v0.2) to  Version 0.3 (Git tag: db_log_db_v0.3) of the Database Logging Module Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBLoggingModule.git)
@@upgrades/external_modules/DB_log_DDL_DML_upgrade_v0.3.sql

--Upgraded from Version 1.3 (Git tag: DVM_db_v1.3) to  Version 1.4 (Git tag: DVM_db_v1.4) of the Data Validation Module Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DataValidationModule.git)
@@upgrades/external_modules/DVM_DDL_DML_upgrade_v1.4.sql



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('DB Module Packager - Scientific Database', '1.0', TO_DATE('21-MAR-23', 'DD-MON-YY'), 'Upgraded from Version 0.2 (Git tag: db_log_db_v0.2) to  Version 0.3 (Git tag: db_log_db_v0.3) of the Database Logging Module Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBLoggingModule.git).  Upgraded from Version 1.3 (Git tag: DVM_db_v1.3) to  Version 1.4 (Git tag: DVM_db_v1.4) of the Data Validation Module Database (Git URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DataValidationModule.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
