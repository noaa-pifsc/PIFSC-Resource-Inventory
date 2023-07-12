--------------------------------------------------------
--------------------------------------------------------
--Database Name: PIFSC Resource Inventory
--Database Description: This project was developed to maintain an inventory of software and data resources to promote reuse of the tools, SOPs, etc. that can be utilized the improve, streamline, and support the data processes within PIFSC
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--PIFSC Resource Inventory - version 1.0 updates:
--------------------------------------------------------

--Upgraded from Version 0.5 (Git tag: DMP_Scientific_v0.5) to Version 1.0 (Git tag: DMP_Scientific_v1.0) of the Scientific Database use case version of the DB Module Packager (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/db-module-packager.git)
@@"./upgrades/external_modules/Science_DB_DDL_DML_upgrade_v1.0.sql"


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('PIFSC Resource Inventory', '1.0', TO_DATE('12-JUL-23', 'DD-MON-YY'), 'Upgraded from Version 0.5 (Git tag: DMP_Scientific_v0.5) to Version 1.0 (Git tag: DMP_Scientific_v1.0) of the Scientific Database use case version of the DB Module Packager (Git URL: git@picgitlab.nmfs.local:centralized-data-tools/db-module-packager.git)');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
