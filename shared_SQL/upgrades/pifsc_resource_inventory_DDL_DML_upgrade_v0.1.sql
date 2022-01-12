--------------------------------------------------------
--------------------------------------------------------
--Database Name: PIFSC Resource Inventory
--Database Description: This project was developed to maintain an inventory of software and data resources to promote reuse of the tools, SOPs, etc. that can be utilized the improve, streamline, and support the data processes within PIFSC
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--PIFSC Resource Inventory - version 0.1 updates:
--------------------------------------------------------


--Installed Version 0.5 (Git tag: DMP_Scientific_v0.5) of the Scientific use case version of the DB Module Packager (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/db-module-packager.git)
@@"./upgrades/external_modules/Science_DB_DDL_DML_upgrade_v0.1.sql"
@@"./upgrades/external_modules/Science_DB_DDL_DML_upgrade_v0.2.sql"
@@"./upgrades/external_modules/Science_DB_DDL_DML_upgrade_v0.3.sql"
@@"./upgrades/external_modules/Science_DB_DDL_DML_upgrade_v0.4.sql"
@@"./upgrades/external_modules/Science_DB_DDL_DML_upgrade_v0.5.sql"


--main version control project table:
CREATE TABLE PRI_PROJ
(
	PROJ_ID NUMBER NOT NULL
, VC_PROJ_ID NUMBER NOT NULL
, PROJ_NAME VARCHAR2 (500) NOT NULL
, PROJ_DESC VARCHAR2 (2000)
, SSH_URL VARCHAR2 (500) NOT NULL
, HTTP_URL VARCHAR2 (500) NOT NULL
, README_URL VARCHAR2 (500)
, AVATAR_URL VARCHAR2 (500)
, PROJ_CREATE_DTM DATE NOT NULL
, PROJ_UPDATE_DTM DATE
, PROJ_VISIBILITY VARCHAR2 (500)
, PROJ_NAME_SPACE VARCHAR2 (500)
, PROJ_SOURCE VARCHAR2 (100)
, CONSTRAINT PRI_PROJ_PK PRIMARY KEY
	(
		PROJ_ID
	)
	ENABLE
);

COMMENT ON TABLE PRI_PROJ IS 'PIFSC Resource Inventory Projects

This table contains the different projects in the PIFSC Resource Inventory';

COMMENT ON COLUMN PRI_PROJ.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_PROJ.VC_PROJ_ID IS 'Unique numeric ID of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_PROJ.PROJ_DESC IS 'Description of the project';
COMMENT ON COLUMN PRI_PROJ.SSH_URL IS 'SSH URL for the project';
COMMENT ON COLUMN PRI_PROJ.HTTP_URL IS 'HTTP URL for the project';
COMMENT ON COLUMN PRI_PROJ.README_URL IS 'Readme URL for the project';
COMMENT ON COLUMN PRI_PROJ.AVATAR_URL IS 'Avatar URL for the project';
COMMENT ON COLUMN PRI_PROJ.PROJ_CREATE_DTM IS 'The date/time the project was created';
COMMENT ON COLUMN PRI_PROJ.PROJ_UPDATE_DTM IS 'The date/time the project was last updated';
COMMENT ON COLUMN PRI_PROJ.PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private)';

COMMENT ON COLUMN PRI_PROJ.PROJ_NAME_SPACE IS 'project name including the namespace prefix';

COMMENT ON COLUMN PRI_PROJ.PROJ_SOURCE IS 'the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)';


ALTER TABLE PRI_PROJ ADD (CREATE_DATE DATE );
ALTER TABLE PRI_PROJ ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE PRI_PROJ ADD (LAST_MOD_DATE DATE );
ALTER TABLE PRI_PROJ ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN PRI_PROJ.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN PRI_PROJ.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN PRI_PROJ.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN PRI_PROJ.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


CREATE SEQUENCE PRI_PROJ_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER PRI_PROJ_AUTO_BRI
before insert on PRI_PROJ
for each row
begin
  select PRI_PROJ_SEQ.nextval into :new.PROJ_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER PRI_PROJ_AUTO_BRU BEFORE
  UPDATE
    ON PRI_PROJ FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



--main version control project table:
CREATE TABLE PRI_PROJ_TAGS
(
	TAG_ID NUMBER NOT NULL
, PROJ_ID NUMBER NOT NULL
, TAG_NAME VARCHAR2 (500) NOT NULL
, TAG_MSG VARCHAR2 (2000)
, TAG_COMMIT_AUTHOR VARCHAR2 (200)
, TAG_COMMIT_DTM DATE
, CONSTRAINT PRI_PROJ_TAGS_PK PRIMARY KEY
	(
		TAG_ID
	)
	ENABLE
);


CREATE INDEX PRI_PROJ_TAGS_I1 ON PRI_PROJ_TAGS (PROJ_ID);

CREATE INDEX PRI_PROJ_TAGS_I2 ON PRI_PROJ_TAGS (TAG_NAME);

ALTER TABLE PRI_PROJ_TAGS
ADD CONSTRAINT PRI_PROJ_TAGS_UK1 UNIQUE
(
  PROJ_ID
, TAG_NAME
)
ENABLE;

ALTER TABLE PRI_PROJ_TAGS
ADD CONSTRAINT PRI_PROJ_TAGS_FK1 FOREIGN KEY
(
  PROJ_ID
)
REFERENCES PRI_PROJ
(
  PROJ_ID
)
ENABLE;

COMMENT ON TABLE PRI_PROJ_TAGS IS 'Project tags

This table stores the Git tags associated with the given project';

COMMENT ON COLUMN PRI_PROJ_TAGS.TAG_ID IS 'Primary key for the PRI_PROJ_TAGS table';

COMMENT ON COLUMN PRI_PROJ_TAGS.PROJ_ID IS 'Foreign key reference to the corresponding project';

COMMENT ON COLUMN PRI_PROJ_TAGS.TAG_NAME IS 'The name of the Git tag';

COMMENT ON COLUMN PRI_PROJ_TAGS.TAG_MSG IS 'The message for the Git tag';

COMMENT ON COLUMN PRI_PROJ_TAGS.TAG_COMMIT_AUTHOR IS 'The author of the tagged commit';
COMMENT ON COLUMN PRI_PROJ_TAGS.TAG_COMMIT_DTM IS 'The date/time the tagged commit was authored';

CREATE SEQUENCE PRI_PROJ_TAGS_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER
PRI_PROJ_TAGS_AUTO_BRI
before insert on PRI_PROJ_TAGS
for each row
begin
  select PRI_PROJ_TAGS_SEQ.nextval into :new.TAG_ID from dual;
end;
/


CREATE OR REPLACE VIEW
PRI_PROJ_TAGS_V
AS
SELECT
PRI_PROJ.PROJ_ID,
PRI_PROJ.VC_PROJ_ID,
PRI_PROJ.PROJ_NAME,
PRI_PROJ.PROJ_DESC,
PRI_PROJ.SSH_URL,
PRI_PROJ.HTTP_URL,
PRI_PROJ.README_URL,
PRI_PROJ.AVATAR_URL,
PRI_PROJ.PROJ_CREATE_DTM,
PRI_PROJ.PROJ_UPDATE_DTM,
PRI_PROJ.PROJ_VISIBILITY,
PRI_PROJ.PROJ_NAME_SPACE,
PRI_PROJ.PROJ_SOURCE,
PRI_PROJ.CREATE_DATE,
PRI_PROJ.CREATED_BY,
PRI_PROJ.LAST_MOD_DATE,
PRI_PROJ.LAST_MOD_BY,
PRI_PROJ_TAGS.TAG_ID,
PRI_PROJ_TAGS.TAG_NAME,
PRI_PROJ_TAGS.TAG_MSG,
PRI_PROJ_TAGS.TAG_COMMIT_AUTHOR,
PRI_PROJ_TAGS.TAG_COMMIT_DTM
FROM
PRI_PROJ INNER JOIN
PRI_PROJ_TAGS ON (PRI_PROJ.PROJ_ID = PRI_PROJ_TAGS.PROJ_ID)
ORDER BY
PRI_PROJ.PROJ_NAME_SPACE,
PRI_PROJ_TAGS.TAG_NAME;

COMMENT ON TABLE PRI_PROJ_TAGS_V IS 'PIFSC Resource Inventory Project Tags (View)

This view returns all projects and the corresponding tags.';


COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.VC_PROJ_ID IS 'Unique numeric ID of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_DESC IS 'Description of the project';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.SSH_URL IS 'SSH URL for the project';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.HTTP_URL IS 'HTTP URL for the project';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.README_URL IS 'Readme URL for the project';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.AVATAR_URL IS 'Avatar URL for the project';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_CREATE_DTM IS 'The date/time the project was created';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_UPDATE_DTM IS 'The date/time the project was last updated';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private)';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_NAME_SPACE IS 'project name including the namespace prefix';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_SOURCE IS 'the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_ID IS 'Primary key for the PRI_PROJ_TAGS table';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_NAME IS 'The name of the Git tag';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_MSG IS 'The message for the Git tag';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_COMMIT_AUTHOR IS 'The author of the tagged commit';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_COMMIT_DTM IS 'The date/time the tagged commit was authored';







--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('PIFSC Resource Inventory', '0.1', TO_DATE('05-JAN-22', 'DD-MON-YY'), 'Installed Version 0.5 (Git tag: DMP_Scientific_v0.5) of the Scientific use case version of the DB Module Packager (Git URL: git@gitlab.pifsc.gov:centralized-data-tools/db-module-packager.git).  Created two new tables (PRI_PROJ and PRI_PROJ_TAGS) to store the project and project tag information from the PIFSC GitLab server.  Created a new view PRI_PROJ_TAGS_V to relate the two tables');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
