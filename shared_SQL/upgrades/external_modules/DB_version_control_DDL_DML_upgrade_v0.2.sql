--------------------------------------------------------
--------------------------------------------------------
--Database Name: Database Version Control 
--Database Description: This database was originally designed track database upgrades over time to different database instances to ensure that the upgrade history for a given database instance is documented and tracked.  
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--Database Version Control - version 0.2 updates:
-------------------------------------------------------------------


ALTER TABLE DB_UPGRADE_LOGS
ADD CONSTRAINT DB_UPGRADE_LOGS_U1 UNIQUE 
(
  UPGRADE_APP_NAME 
, UPGRADE_VERSION 
)
ENABLE;



--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Database Version Control', '0.2', TO_DATE('17-NOV-17', 'DD-MON-YY'), 'Implemented a unique key constraint that requires the application name and version to be unique so that the same update cannot be entered into the database upgrade log table');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;