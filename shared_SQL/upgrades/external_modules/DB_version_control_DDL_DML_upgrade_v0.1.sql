--------------------------------------------------------
--------------------------------------------------------
--Database Name: Database Version Control 
--Database Description: This database was originally designed track database upgrades over time to different database instances to ensure that the upgrade history for a given database instance is documented and tracked.  
--------------------------------------------------------
--------------------------------------------------------


-------------------------------------------------------------------
--Database Version Control - version 0.1 updates:
-------------------------------------------------------------------

CREATE TABLE DB_UPGRADE_LOGS 
(
  UPGRADE_LOG_ID NUMBER NOT NULL 
, UPGRADE_APP_NAME VARCHAR2(200) NOT NULL
, UPGRADE_VERSION VARCHAR2(10) NOT NULL 
, UPGRADE_DATE DATE NOT NULL 
, UPGRADE_APP_DATE DATE NOT NULL 
, UPGRADE_DESC VARCHAR2(2000) 
, CONSTRAINT DB_UPGRADE_LOGS_PK PRIMARY KEY 
  (
    UPGRADE_LOG_ID 
  )
  ENABLE 
);

COMMENT ON COLUMN DB_UPGRADE_LOGS.UPGRADE_VERSION IS 'The numeric version of the database upgrade that was applied';

COMMENT ON COLUMN DB_UPGRADE_LOGS.UPGRADE_APP_NAME IS 'The name of the database/database module that was upgraded';


COMMENT ON COLUMN DB_UPGRADE_LOGS.UPGRADE_DATE IS 'The date/time that the upgrade was released';

COMMENT ON COLUMN DB_UPGRADE_LOGS.UPGRADE_APP_DATE IS 'The date/time that the upgrade was applied to the current database instance';

COMMENT ON COLUMN DB_UPGRADE_LOGS.UPGRADE_DESC IS 'Description of the given database upgrade';

CREATE SEQUENCE DB_UPGRADE_LOGS_SEQ INCREMENT BY 1 START WITH 1;

COMMENT ON TABLE DB_UPGRADE_LOGS IS 'Database Upgrade Log

This database table stores the upgrade history for a given database instance so it is clear what each database instance''s version is.  This is used to apply the necessary database upgrades in order to deploy a given version of an associated application.';

COMMENT ON COLUMN DB_UPGRADE_LOGS.UPGRADE_LOG_ID IS 'Primary Key for the DB_UPGRADE_LOGS table';


ALTER TABLE DB_UPGRADE_LOGS 
ADD (UPGRADE_BY VARCHAR2(30) );


COMMENT ON COLUMN DB_UPGRADE_LOGS.UPGRADE_APP_DATE IS 'The date/time when the upgrade was applied to the database';
COMMENT ON COLUMN DB_UPGRADE_LOGS.UPGRADE_BY IS 'The Oracle username of the account that applied the upgrade to the database';


create or replace TRIGGER DB_UPGRADE_LOGS_AUTO_BRI
before insert on DB_UPGRADE_LOGS
for each row
begin
  select DB_UPGRADE_LOGS_SEQ.nextval into :new.UPGRADE_LOG_ID from dual;
  :NEW.UPGRADE_APP_DATE := SYSDATE;
  :NEW.UPGRADE_BY := nvl(v('APP_USER'),user);
end;
/


create or replace view
DB_UPGRADE_LOGS_V
AS
SELECT
    db_upgrade_logs.upgrade_log_id,
    db_upgrade_logs.UPGRADE_APP_NAME,
    db_upgrade_logs.upgrade_version,
    db_upgrade_logs.upgrade_date,
    to_char(db_upgrade_logs.upgrade_date, 'MM/DD/YYYY HH24:MI') form_upgrade_date,
    db_upgrade_logs.upgrade_app_date,
    to_char(db_upgrade_logs.upgrade_app_date, 'MM/DD/YYYY HH24:MI') form_upgrade_app_date,
    db_upgrade_logs.upgrade_desc,
    db_upgrade_logs.upgrade_by
FROM
    db_upgrade_logs order by UPGRADE_APP_NAME, upgrade_date, upgrade_version;


COMMENT ON COLUMN DB_UPGRADE_LOGS_V.UPGRADE_LOG_ID IS 'Primary Key for the DB_UPGRADE_LOGS table';
COMMENT ON COLUMN DB_UPGRADE_LOGS_V.UPGRADE_VERSION IS 'The numeric version of the database upgrade that was applied';
COMMENT ON COLUMN DB_UPGRADE_LOGS_V.UPGRADE_DATE IS 'The date/time that the upgrade was released';
COMMENT ON COLUMN DB_UPGRADE_LOGS_V.FORM_UPGRADE_DATE IS 'The formatted date/time that the upgrade was released';
COMMENT ON COLUMN DB_UPGRADE_LOGS_V.UPGRADE_APP_DATE IS 'The date/time when the upgrade was applied to the database';
COMMENT ON COLUMN DB_UPGRADE_LOGS_V.FORM_UPGRADE_APP_DATE IS 'The formatted date/time when the upgrade was applied to the database';
COMMENT ON COLUMN DB_UPGRADE_LOGS_V.UPGRADE_DESC IS 'Description of the given database upgrade';
COMMENT ON COLUMN DB_UPGRADE_LOGS_V.UPGRADE_BY IS 'The Oracle username of the account that applied the upgrade to the database';
COMMENT ON COLUMN DB_UPGRADE_LOGS_V.UPGRADE_APP_NAME IS 'The name of the database/database module that was upgraded';

COMMENT ON TABLE DB_UPGRADE_LOGS_V IS 'Database Upgrade Log (View)

This view returns the log of all database upgrades applied to a given database ordered by the date the upgrade was released.  This view includes formatted upgrade release and upgrade application dates';



--define the upgrade version in the database:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('Database Version Control', '0.1', TO_DATE('10-AUG-17', 'DD-MON-YY'), 'Initial version of the database upgrade log table and support objects');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;