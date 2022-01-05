--------------------------------------------------------
--------------------------------------------------------
--Database Name: Data Validation Module
--Database Description: This module was developed to perform systematic data quality control (QC) on a given set of data tables so the data issues can be stored in a single table and easily reviewed to identify and resolve/annotate data issues
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--version 0.2 updates:
--------------------------------------------------------


insert into DVM_ERR_SEVERITY (ERR_SEVERITY_CODE, ERR_SEVERITY_NAME, ERR_SEVERITY_DESC) values ('WARN', 'Warning', 'Warning that indicates that a given value or set of values is not typical but acceptable');
insert into DVM_ERR_SEVERITY (ERR_SEVERITY_CODE, ERR_SEVERITY_NAME, ERR_SEVERITY_DESC) values ('FATAL', 'Fatal Data Error', 'Error that indicates that a given value or set of values is invalid and cannot happen based on the business rules and validation criteria.  This must be resolved before the data can be certified.');


--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Data Validation Module', '0.2', TO_DATE('20-SEP-17', 'DD-MON-YY'), 'Updated the module to set some default error severity records (fatal and warnings)');