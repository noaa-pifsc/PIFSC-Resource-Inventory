--------------------------------------------------------
--------------------------------------------------------
--Database Name: Database Log
--Database Description: This module was created to log information in the database for various backend operations.  This is preferable to a file-based log since it can be easily queried, filtered, searched, and used for reporting purposes
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--Database Log - version 0.2 updates:
--------------------------------------------------------

--increase the size of the DB_LOG_ENTRIES.LOG_SOURCE table field to accommodate additional use cases
ALTER TABLE DB_LOG_ENTRIES
MODIFY (LOG_SOURCE VARCHAR2(2000 BYTE) );

--recompile the dependent view since the view source table definition has changed
ALTER VIEW DB_LOG_ENTRIES_V COMPILE;

--recompile the package since the source table definition has changed
ALTER PACKAGE DB_LOG_PKG COMPILE;

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Database Log', '0.2', TO_DATE('08-JUL-20', 'DD-MON-YY'), 'Increased the size of DB_LOG_ENTRIES.LOG_SOURCE to accommodate additional use cases.  Recompiled the dependent view DB_LOG_ENTRIES_V');
