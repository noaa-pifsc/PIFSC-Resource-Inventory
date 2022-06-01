--------------------------------------------------------
--------------------------------------------------------
--Database Name: PIFSC Resource Inventory
--Database Description: This project was developed to maintain an inventory of software and data resources to promote reuse of the tools, SOPs, etc. that can be utilized the improve, streamline, and support the data processes within PIFSC
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--PIFSC Resource Inventory - version 0.4 updates:
--------------------------------------------------------


CREATE TABLE PRI_DATA_SOURCES
(
  DATA_SOURCE_ID NUMBER NOT NULL
, DATA_SOURCE_CODE VARCHAR2(50)
, DATA_SOURCE_NAME VARCHAR2(200) NOT NULL
, DATA_SOURCE_DESC VARCHAR2(500)
, CONSTRAINT PRI_DATA_SOURCES_PK PRIMARY KEY
  (
    DATA_SOURCE_ID
  )
  ENABLE
);

COMMENT ON COLUMN PRI_DATA_SOURCES.DATA_SOURCE_ID IS 'Primary key for the Data Sources table';

COMMENT ON COLUMN PRI_DATA_SOURCES.DATA_SOURCE_CODE IS 'Code for the given Data Source';

COMMENT ON COLUMN PRI_DATA_SOURCES.DATA_SOURCE_NAME IS 'Name of the given Data Source';

COMMENT ON COLUMN PRI_DATA_SOURCES.DATA_SOURCE_DESC IS 'Description for the given Data Source';

COMMENT ON TABLE PRI_DATA_SOURCES IS 'PIFSC Resource Inventory Data Sources

This table defines the different data sources for the information in the PIFSC Resource Inventory Database';


ALTER TABLE PRI_DATA_SOURCES ADD (CREATE_DATE DATE );
ALTER TABLE PRI_DATA_SOURCES ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE PRI_DATA_SOURCES ADD (LAST_MOD_DATE DATE );
ALTER TABLE PRI_DATA_SOURCES ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN PRI_DATA_SOURCES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN PRI_DATA_SOURCES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN PRI_DATA_SOURCES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN PRI_DATA_SOURCES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


ALTER TABLE PRI_DATA_SOURCES ADD CONSTRAINT PRI_DATA_SOURCES_U1 UNIQUE
(
  DATA_SOURCE_CODE
)
ENABLE;

ALTER TABLE PRI_DATA_SOURCES ADD CONSTRAINT PRI_DATA_SOURCES_U2 UNIQUE
(
  DATA_SOURCE_NAME
)
ENABLE;

CREATE SEQUENCE PRI_DATA_SOURCES_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER PRI_DATA_SOURCES_AUTO_BRI
before insert on PRI_DATA_SOURCES
for each row
begin
  select PRI_DATA_SOURCES_SEQ.nextval into :new.DATA_SOURCE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/
CREATE OR REPLACE TRIGGER PRI_DATA_SOURCES_AUTO_BRU BEFORE
  UPDATE
    ON PRI_DATA_SOURCES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/





CREATE TABLE PRI_VC_USERS
(
  USER_ID NUMBER NOT NULL
, VC_USER_ID NUMBER NOT NULL
, USERNAME VARCHAR2(100) NOT NULL
, USER_NAME VARCHAR2(100) NOT NULL
, USER_EMAIL VARCHAR2(200) NOT NULL
, AVATAR_URL VARCHAR2(500) NOT NULL
, WEB_URL VARCHAR2(500) NOT NULL
, DATA_SOURCE_ID NUMBER NOT NULL
, CONSTRAINT PRI_USERS_PK PRIMARY KEY
  (
    USER_ID
  )
  ENABLE
);

COMMENT ON COLUMN PRI_VC_USERS.USER_ID IS 'Primary key for the PRI_VC_USERS table';

COMMENT ON COLUMN PRI_VC_USERS.VC_USER_ID IS 'Unique User ID for user within the version control system';

COMMENT ON COLUMN PRI_VC_USERS.USERNAME IS 'Login username for the user account in the version control system';

COMMENT ON COLUMN PRI_VC_USERS.USER_NAME IS 'Name of the user account in the version control system';

COMMENT ON COLUMN PRI_VC_USERS.USER_EMAIL IS 'Email for the user account in the version control system';

COMMENT ON COLUMN PRI_VC_USERS.AVATAR_URL IS 'Avatar URL for the user account in the version control system';

COMMENT ON COLUMN PRI_VC_USERS.WEB_URL IS 'Web URL for the user account in the version control system';

COMMENT ON COLUMN PRI_VC_USERS.DATA_SOURCE_ID IS 'Foreign key reference to the data sources record for the given user account in the version control system';

COMMENT ON TABLE PRI_VC_USERS IS 'PIFSC Resource Inventory Version Control Users

This table stores the version control users so they can be associated with the projects they created/own';


ALTER TABLE PRI_VC_USERS ADD (CREATE_DATE DATE );
ALTER TABLE PRI_VC_USERS ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE PRI_VC_USERS ADD (LAST_MOD_DATE DATE );
ALTER TABLE PRI_VC_USERS ADD (LAST_MOD_BY VARCHAR2(30) );

COMMENT ON COLUMN PRI_VC_USERS.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN PRI_VC_USERS.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN PRI_VC_USERS.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN PRI_VC_USERS.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


CREATE INDEX PRI_VC_USERS_I1 ON PRI_VC_USERS (VC_USER_ID);

CREATE INDEX PRI_VC_USERS_I2 ON PRI_VC_USERS (DATA_SOURCE_ID);

ALTER TABLE PRI_VC_USERS
ADD CONSTRAINT PRI_VC_USERS_FK1 FOREIGN KEY
(
  DATA_SOURCE_ID
)
REFERENCES PRI_DATA_SOURCES
(
  DATA_SOURCE_ID
)
ENABLE;

ALTER TABLE PRI_VC_USERS
ADD CONSTRAINT PRI_VC_USERS_U1 UNIQUE
(
  VC_USER_ID
, DATA_SOURCE_ID
)
ENABLE;


CREATE SEQUENCE PRI_VC_USERS_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER PRI_VC_USERS_AUTO_BRI
before insert on PRI_VC_USERS
for each row
begin
  select PRI_VC_USERS_SEQ.nextval into :new.USER_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

CREATE OR REPLACE TRIGGER PRI_VC_USERS_AUTO_BRU BEFORE
  UPDATE
    ON PRI_VC_USERS FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


ALTER TABLE PRI_PROJ RENAME COLUMN PROJ_SOURCE TO DATA_SOURCE_ID;

ALTER TABLE PRI_PROJ
MODIFY (DATA_SOURCE_ID NUMBER NOT NULL);

COMMENT ON COLUMN PRI_PROJ.DATA_SOURCE_ID IS 'foreign key reference to the data source record for the project record (e.g. PIFSC GitLab, GitHub, manual entry)';


ALTER TABLE PRI_PROJ
ADD (VC_OWNER_ID NUMBER);

ALTER TABLE PRI_PROJ
ADD (VC_CREATOR_ID NUMBER NOT NULL);

ALTER TABLE PRI_PROJ
ADD (VC_WEB_URL VARCHAR2(500) NOT NULL);

ALTER TABLE PRI_PROJ
ADD (VC_OPEN_ISSUES_COUNT NUMBER(*, 0) NOT NULL);

ALTER TABLE PRI_PROJ
ADD (VC_COMMIT_COUNT NUMBER(*, 0) NOT NULL);

ALTER TABLE PRI_PROJ
ADD (VC_REPO_SIZE NUMBER(*, 0) NOT NULL);


ALTER TABLE PRI_PROJ
ADD CONSTRAINT PRI_PROJ_U1 UNIQUE
(
  VC_PROJ_ID
, DATA_SOURCE_ID
)
ENABLE;


COMMENT ON COLUMN PRI_PROJ.VC_OWNER_ID IS 'Unique numeric User ID of the project''s owner in the given version control system';

COMMENT ON COLUMN PRI_PROJ.VC_CREATOR_ID IS 'Unique numeric User ID of the project''s creator in the given version control system';

COMMENT ON COLUMN PRI_PROJ.VC_WEB_URL IS 'The web URL of the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ.VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ.VC_COMMIT_COUNT IS 'The total number of commits for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ.VC_REPO_SIZE IS 'The total repository size in bytes for the project in the given version control system';




CREATE OR REPLACE VIEW
PRI_VC_USERS_V
AS
SELECT
PRI_VC_USERS.USER_ID,
PRI_VC_USERS.VC_USER_ID,
PRI_VC_USERS.USERNAME,
PRI_VC_USERS.USER_NAME,
PRI_VC_USERS.USER_EMAIL,
PRI_VC_USERS.AVATAR_URL,
PRI_VC_USERS.WEB_URL,
PRI_DATA_SOURCES.DATA_SOURCE_ID,
PRI_DATA_SOURCES.DATA_SOURCE_CODE,
PRI_DATA_SOURCES.DATA_SOURCE_NAME,
PRI_DATA_SOURCES.DATA_SOURCE_DESC,
PRI_VC_USERS.CREATE_DATE,
PRI_VC_USERS.CREATED_BY,
PRI_VC_USERS.LAST_MOD_DATE,
PRI_VC_USERS.LAST_MOD_BY

FROM PRI_VC_USERS
INNER JOIN PRI_DATA_SOURCES ON
PRI_VC_USERS.DATA_SOURCE_ID = PRI_DATA_SOURCES.DATA_SOURCE_ID
order by upper(PRI_VC_USERS.USER_NAME);

COMMENT ON TABLE PRI_VC_USERS_V IS 'PIFSC Resource Inventory Version Control Users (View)

This query returns the version control users and the associated data source information';

COMMENT ON COLUMN PRI_VC_USERS_V.USER_ID IS 'Primary key for the PRI_VC_USERS table';
COMMENT ON COLUMN PRI_VC_USERS_V.VC_USER_ID IS 'Unique User ID for user within the version control system';
COMMENT ON COLUMN PRI_VC_USERS_V.USERNAME IS 'Login username for the user account in the version control system';
COMMENT ON COLUMN PRI_VC_USERS_V.USER_NAME IS 'Name of the user account in the version control system';
COMMENT ON COLUMN PRI_VC_USERS_V.USER_EMAIL IS 'Email for the user account in the version control system';
COMMENT ON COLUMN PRI_VC_USERS_V.AVATAR_URL IS 'Avatar URL for the user account in the version control system';
COMMENT ON COLUMN PRI_VC_USERS_V.WEB_URL IS 'Web URL for the user account in the version control system';
COMMENT ON COLUMN PRI_VC_USERS_V.DATA_SOURCE_ID IS 'Primary key for the Data Sources table';
COMMENT ON COLUMN PRI_VC_USERS_V.DATA_SOURCE_CODE IS 'Code for the given Data Source';
COMMENT ON COLUMN PRI_VC_USERS_V.DATA_SOURCE_NAME IS 'Name of the given Data Source';
COMMENT ON COLUMN PRI_VC_USERS_V.DATA_SOURCE_DESC IS 'Description for the given Data Source';
COMMENT ON COLUMN PRI_VC_USERS_V.CREATE_DATE IS 'The date on which this user was created in the database';
COMMENT ON COLUMN PRI_VC_USERS_V.CREATED_BY IS 'The Oracle username of the person creating the user in the database';
COMMENT ON COLUMN PRI_VC_USERS_V.LAST_MOD_DATE IS 'The last date on which any of the data in the user was changed';
COMMENT ON COLUMN PRI_VC_USERS_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this user';



CREATE OR REPLACE VIEW
PRI_PROJ_V

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

PRI_DATA_SOURCES.DATA_SOURCE_ID,
PRI_DATA_SOURCES.DATA_SOURCE_CODE,
PRI_DATA_SOURCES.DATA_SOURCE_NAME,
PRI_DATA_SOURCES.DATA_SOURCE_DESC,


PRI_PROJ.VC_OWNER_ID,
OWNER.USER_ID OWNER_USER_ID,
OWNER.USERNAME OWNER_USERNAME,
OWNER.USER_NAME OWNER_USER_NAME,
OWNER.USER_EMAIL OWNER_USER_EMAIL,
OWNER.AVATAR_URL OWNER_AVATAR_URL,
OWNER.WEB_URL OWNER_WEB_URL,


PRI_PROJ.VC_CREATOR_ID,
CREATOR.USER_ID CREATOR_USER_ID,
CREATOR.USERNAME CREATOR_USERNAME,
CREATOR.USER_NAME CREATOR_USER_NAME,
CREATOR.USER_EMAIL CREATOR_USER_EMAIL,
CREATOR.AVATAR_URL CREATOR_AVATAR_URL,
CREATOR.WEB_URL CREATOR_WEB_URL,

PRI_PROJ.VC_WEB_URL,
PRI_PROJ.VC_OPEN_ISSUES_COUNT,
PRI_PROJ.VC_COMMIT_COUNT,
PRI_PROJ.VC_REPO_SIZE,
ROUND((PRI_PROJ.VC_REPO_SIZE / 1024) / 1024, 2) VC_REPO_SIZE_MB,
TRIM(TO_CHAR(ROUND((PRI_PROJ.VC_REPO_SIZE / 1024) / 1024, 2), '999,990.99')) FORMAT_VC_REPO_SIZE_MB,
PRI_PROJ.CREATE_DATE,
PRI_PROJ.CREATED_BY,
PRI_PROJ.LAST_MOD_DATE,
PRI_PROJ.LAST_MOD_BY,
NVL(PRI_PROJ.LAST_MOD_DATE, PRI_PROJ.CREATE_DATE) PROJ_REFRESH_DATE,


PRI_RES_V.RES_ID,
PRI_RES_V.RES_CATEGORY,
PRI_RES_V.RES_TAG_CONV,
PRI_RES_V.RES_NAME,
PRI_RES_V.RES_COLOR_CODE,
PRI_RES_V.RES_URL,
PRI_RES_V.RES_SCOPE_ID,
PRI_RES_V.RES_SCOPE_CODE,
PRI_RES_V.RES_SCOPE_NAME,
PRI_RES_V.RES_SCOPE_DESC,
PRI_RES_V.RES_TYPE_ID,
PRI_RES_V.RES_TYPE_CODE,
PRI_RES_V.RES_TYPE_NAME,
PRI_RES_V.RES_TYPE_DESC,
PRI_RES_V.RES_DESC,
PRI_RES_V.RES_DEMO_URL
FROM PRI_PROJ
INNER JOIN PRI_DATA_SOURCES ON PRI_PROJ.DATA_SOURCE_ID = PRI_DATA_SOURCES.DATA_SOURCE_ID
LEFT JOIN PRI_RES_V ON PRI_PROJ.PROJ_ID = PRI_RES_V.PROJ_ID
LEFT JOIN PRI_VC_USERS_V CREATOR ON PRI_PROJ.VC_CREATOR_ID = CREATOR.VC_USER_ID AND CREATOR.DATA_SOURCE_ID = PRI_PROJ.DATA_SOURCE_ID
LEFT JOIN PRI_VC_USERS_V OWNER ON PRI_PROJ.VC_OWNER_ID = OWNER.VC_USER_ID
ORDER BY
PRI_PROJ.PROJ_NAME_SPACE,
PRI_RES_V.RES_NAME,
PRI_RES_V.RES_TYPE_NAME,
PRI_RES_V.RES_SCOPE_NAME
;

COMMENT ON TABLE PRI_PROJ_V IS 'Projects (View)

This view returns all project records and any associated project resources and associated reference table information';


COMMENT ON COLUMN PRI_PROJ_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_PROJ_V.VC_PROJ_ID IS 'Unique numeric ID of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_PROJ_V.PROJ_DESC IS 'Description of the project';
COMMENT ON COLUMN PRI_PROJ_V.SSH_URL IS 'SSH URL for the project';
COMMENT ON COLUMN PRI_PROJ_V.HTTP_URL IS 'HTTP URL for the project';
COMMENT ON COLUMN PRI_PROJ_V.README_URL IS 'Readme URL for the project';
COMMENT ON COLUMN PRI_PROJ_V.AVATAR_URL IS 'Avatar URL for the project';
COMMENT ON COLUMN PRI_PROJ_V.PROJ_CREATE_DTM IS 'The date/time the project was created';
COMMENT ON COLUMN PRI_PROJ_V.PROJ_UPDATE_DTM IS 'The date/time the project was last updated';
COMMENT ON COLUMN PRI_PROJ_V.PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private)';
COMMENT ON COLUMN PRI_PROJ_V.PROJ_NAME_SPACE IS 'project name including the namespace prefix';

COMMENT ON COLUMN PRI_PROJ_V.DATA_SOURCE_ID IS 'Primary key for the project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_V.DATA_SOURCE_CODE IS 'Code for the given project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_V.DATA_SOURCE_NAME IS 'Name of the given project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_V.DATA_SOURCE_DESC IS 'Description for the given project''s Data Source';



COMMENT ON COLUMN PRI_PROJ_V.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_PROJ_V.RES_CATEGORY IS 'The resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications';
COMMENT ON COLUMN PRI_PROJ_V.RES_TAG_CONV IS 'Tag Naming convention used to identify the given project resource''s version.  The suffix is required to be a series of period-delimited numbers (e.g. for a naming convention of db_module_packager_v the tag value of db_module_packager_v1.13.4 is valid)';
COMMENT ON COLUMN PRI_PROJ_V.RES_NAME IS 'The name of the project resource';
COMMENT ON COLUMN PRI_PROJ_V.RES_COLOR_CODE IS 'The color code for the project resource';
COMMENT ON COLUMN PRI_PROJ_V.RES_URL IS 'The URL for the project resource (this is blank when the repository URL is the same as the resource URL)';
COMMENT ON COLUMN PRI_PROJ_V.RES_SCOPE_ID IS 'Foreign key reference to the resource scope';
COMMENT ON COLUMN PRI_PROJ_V.RES_SCOPE_CODE IS 'Code for the given Resource Scope';
COMMENT ON COLUMN PRI_PROJ_V.RES_SCOPE_NAME IS 'Name of the given Resource Scope';
COMMENT ON COLUMN PRI_PROJ_V.RES_SCOPE_DESC IS 'Description for the given Resource Scope';
COMMENT ON COLUMN PRI_PROJ_V.RES_TYPE_ID IS 'Foreign key reference to the resource type';
COMMENT ON COLUMN PRI_PROJ_V.RES_TYPE_CODE IS 'Code for the given Resource Type';
COMMENT ON COLUMN PRI_PROJ_V.RES_TYPE_NAME IS 'Name of the given Resource Type';
COMMENT ON COLUMN PRI_PROJ_V.RES_TYPE_DESC IS 'Description for the given Resource Type';

COMMENT ON COLUMN PRI_PROJ_V.RES_DESC IS 'The description for the project resource';

COMMENT ON COLUMN PRI_PROJ_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';


COMMENT ON COLUMN PRI_PROJ_V.VC_OWNER_ID IS 'Unique numeric User ID of the project''s owner in the given version control system';
COMMENT ON COLUMN PRI_PROJ_V.VC_CREATOR_ID IS 'Unique numeric User ID of the project''s creator in the given version control system';
COMMENT ON COLUMN PRI_PROJ_V.VC_WEB_URL IS 'The web URL of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_V.VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_V.VC_COMMIT_COUNT IS 'The total number of commits for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_V.VC_REPO_SIZE IS 'The total repository size in bytes for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_V.VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_V.FORMAT_VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system formatted as a string with a leading zero for values < 1';

COMMENT ON COLUMN PRI_PROJ_V.CREATE_DATE IS 'The date the project record was created in the database';
COMMENT ON COLUMN PRI_PROJ_V.CREATED_BY IS 'The Oracle username of the person that created the project record in the database';
COMMENT ON COLUMN PRI_PROJ_V.LAST_MOD_DATE IS 'The last date on which any of the data in the project record was changed';
COMMENT ON COLUMN PRI_PROJ_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the project record';

COMMENT ON COLUMN PRI_PROJ_V.PROJ_REFRESH_DATE IS 'The date of the last time the project information was refreshed in the database';



COMMENT ON COLUMN PRI_PROJ_V.OWNER_USER_ID IS 'The Project Owner''s User ID for the version control system';
COMMENT ON COLUMN PRI_PROJ_V.OWNER_USERNAME IS 'Login username for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.OWNER_USER_NAME IS 'Name of the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.OWNER_USER_EMAIL IS 'Email for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.OWNER_AVATAR_URL IS 'Avatar URL for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.OWNER_WEB_URL IS 'Web URL for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.CREATOR_USER_ID IS 'The Project Creator''s User ID for the version control system';
COMMENT ON COLUMN PRI_PROJ_V.CREATOR_USERNAME IS 'Login username for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.CREATOR_USER_NAME IS 'Name of the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.CREATOR_USER_EMAIL IS 'Email for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.CREATOR_AVATAR_URL IS 'Avatar URL for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_V.CREATOR_WEB_URL IS 'Web URL for the project creator''s user account in the version control system';

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



PRI_DATA_SOURCES.DATA_SOURCE_ID,
PRI_DATA_SOURCES.DATA_SOURCE_CODE,
PRI_DATA_SOURCES.DATA_SOURCE_NAME,
PRI_DATA_SOURCES.DATA_SOURCE_DESC,


PRI_PROJ.VC_OWNER_ID,
PRI_PROJ.VC_CREATOR_ID,
PRI_PROJ.VC_WEB_URL,
PRI_PROJ.VC_OPEN_ISSUES_COUNT,
PRI_PROJ.VC_COMMIT_COUNT,
PRI_PROJ.VC_REPO_SIZE,
ROUND((PRI_PROJ.VC_REPO_SIZE / 1024) / 1024, 2) VC_REPO_SIZE_MB,
TRIM(TO_CHAR(ROUND((PRI_PROJ.VC_REPO_SIZE / 1024) / 1024, 2), '999,990.99')) FORMAT_VC_REPO_SIZE_MB,
PRI_PROJ.CREATE_DATE,
PRI_PROJ.CREATED_BY,
PRI_PROJ.LAST_MOD_DATE,
PRI_PROJ.LAST_MOD_BY,
NVL(PRI_PROJ.LAST_MOD_DATE, PRI_PROJ.CREATE_DATE) PROJ_REFRESH_DATE,




PRI_PROJ_TAGS.TAG_ID,
PRI_PROJ_TAGS.TAG_NAME,
PRI_PROJ_TAGS.TAG_MSG,
PRI_PROJ_TAGS.TAG_COMMIT_AUTHOR,
PRI_PROJ_TAGS.TAG_COMMIT_DTM
FROM
PRI_PROJ
INNER JOIN PRI_DATA_SOURCES ON PRI_PROJ.DATA_SOURCE_ID = PRI_DATA_SOURCES.DATA_SOURCE_ID
INNER JOIN
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

COMMENT ON COLUMN PRI_PROJ_TAGS_V.DATA_SOURCE_ID IS 'Primary key for the project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.DATA_SOURCE_CODE IS 'Code for the given project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.DATA_SOURCE_NAME IS 'Name of the given project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.DATA_SOURCE_DESC IS 'Description for the given project''s Data Source';




COMMENT ON COLUMN PRI_PROJ_TAGS_V.CREATE_DATE IS 'The date the project record was created in the database';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.CREATED_BY IS 'The Oracle username of the person creating this project record in the database';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.LAST_MOD_DATE IS 'The last date on which any of the data in the project record was changed';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this project record';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_ID IS 'Primary key for the PRI_PROJ_TAGS table';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_NAME IS 'The name of the Git tag';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_MSG IS 'The message for the Git tag';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_COMMIT_AUTHOR IS 'The author of the tagged commit';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.TAG_COMMIT_DTM IS 'The date/time the tagged commit was authored';

COMMENT ON COLUMN PRI_PROJ_TAGS_V.VC_OWNER_ID IS 'Unique numeric User ID of the project''s owner in the given version control system';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.VC_CREATOR_ID IS 'Unique numeric User ID of the project''s creator in the given version control system';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.VC_WEB_URL IS 'The web URL of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_TAGS_V.VC_COMMIT_COUNT IS 'The total number of commits for the project in the given version control system';


COMMENT ON COLUMN PRI_PROJ_TAGS_V.VC_REPO_SIZE IS 'The total repository size in bytes for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_TAGS_V.VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_TAGS_V.FORMAT_VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system formatted as a string with a leading zero for values < 1';

COMMENT ON COLUMN PRI_PROJ_TAGS_V.PROJ_REFRESH_DATE IS 'The date of the last time the project information was refreshed in the database';

--Detailed query to show all associations of each project and resource along with the highest version of each module
CREATE OR REPLACE VIEW PRI_PROJ_RES_TAG_MAX_V

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



PRI_DATA_SOURCES.DATA_SOURCE_ID,
PRI_DATA_SOURCES.DATA_SOURCE_CODE,
PRI_DATA_SOURCES.DATA_SOURCE_NAME,
PRI_DATA_SOURCES.DATA_SOURCE_DESC,

PRI_PROJ.VC_OWNER_ID,
PRI_PROJ.VC_CREATOR_ID,
PRI_PROJ.VC_WEB_URL,
PRI_PROJ.VC_OPEN_ISSUES_COUNT,
PRI_PROJ.VC_COMMIT_COUNT,
PRI_PROJ.VC_REPO_SIZE,
ROUND((PRI_PROJ.VC_REPO_SIZE / 1024) / 1024, 2) VC_REPO_SIZE_MB,
TRIM(TO_CHAR(ROUND((PRI_PROJ.VC_REPO_SIZE / 1024) / 1024, 2), '999,990.99')) FORMAT_VC_REPO_SIZE_MB,

PRI_PROJ.CREATE_DATE,
PRI_PROJ.CREATED_BY,
PRI_PROJ.LAST_MOD_DATE,
PRI_PROJ.LAST_MOD_BY,
NVL(PRI_PROJ.LAST_MOD_DATE, PRI_PROJ.CREATE_DATE) PROJ_REFRESH_DATE,




RES_PROJ_VERS.MAX_TAG_ID RES_MAX_TAG_ID,
RES_PROJ_VERS.MAX_VERS_NUM RES_MAX_VERS_NUM,
TAG_PROJ_VERS.MAX_TAG_ID TAG_PROJ_MAX_TAG_ID,
TAG_PROJ_VERS.MAX_VERS_NUM TAG_PROJ_MAX_VERS_NUM,
(CASE WHEN RES_PROJ_VERS.MAX_VERS_NUM = TAG_PROJ_VERS.MAX_VERS_NUM THEN 'Y' WHEN RES_PROJ_VERS.MAX_VERS_NUM IS NULL OR TAG_PROJ_VERS.MAX_VERS_NUM IS NULL THEN NULL ELSE 'N' END) TAG_MAX_VERS_YN,
(CASE WHEN RES_PROJ_VERS.MAX_VERS_NUM = TAG_PROJ_VERS.MAX_VERS_NUM THEN 'Current Version' WHEN RES_PROJ_VERS.MAX_VERS_NUM IS NULL OR TAG_PROJ_VERS.MAX_VERS_NUM IS NULL THEN NULL ELSE 'Update Available' END) RES_VERS_STATUS,
PRI_PROJ_V.PROJ_ID RES_PROJ_ID,
PRI_PROJ_V.VC_PROJ_ID RES_VC_PROJ_ID,
PRI_PROJ_V.PROJ_NAME RES_PROJ_NAME,
PRI_PROJ_V.PROJ_DESC RES_PROJ_DESC,
PRI_PROJ_V.SSH_URL RES_SSH_URL,
PRI_PROJ_V.HTTP_URL RES_HTTP_URL,
PRI_PROJ_V.README_URL RES_README_URL,
PRI_PROJ_V.AVATAR_URL RES_AVATAR_URL,
PRI_PROJ_V.PROJ_CREATE_DTM RES_PROJ_CREATE_DTM,
PRI_PROJ_V.PROJ_UPDATE_DTM RES_PROJ_UPDATE_DTM,
PRI_PROJ_V.PROJ_VISIBILITY RES_PROJ_VISIBILITY,
PRI_PROJ_V.PROJ_NAME_SPACE RES_PROJ_NAME_SPACE,

PRI_PROJ_V.DATA_SOURCE_ID RES_DATA_SOURCE_ID,
PRI_PROJ_V.DATA_SOURCE_CODE RES_DATA_SOURCE_CODE,
PRI_PROJ_V.DATA_SOURCE_NAME RES_DATA_SOURCE_NAME,
PRI_PROJ_V.DATA_SOURCE_DESC RES_DATA_SOURCE_DESC,




PRI_PROJ_V.VC_OWNER_ID RES_VC_OWNER_ID,
PRI_PROJ_V.VC_CREATOR_ID RES_VC_CREATOR_ID,
PRI_PROJ_V.VC_WEB_URL RES_VC_WEB_URL,
PRI_PROJ_V.VC_OPEN_ISSUES_COUNT RES_VC_OPEN_ISSUES_COUNT,
PRI_PROJ_V.VC_COMMIT_COUNT RES_VC_COMMIT_COUNT,
PRI_PROJ_V.VC_REPO_SIZE RES_VC_REPO_SIZE,
PRI_PROJ_V.VC_REPO_SIZE_MB RES_VC_REPO_SIZE_MB,
PRI_PROJ_V.FORMAT_VC_REPO_SIZE_MB RES_FORMAT_VC_REPO_SIZE_MB,
PRI_PROJ_V.RES_ID,
PRI_PROJ_V.RES_CATEGORY,
PRI_PROJ_V.RES_TAG_CONV,
PRI_PROJ_V.RES_NAME,
PRI_PROJ_V.RES_COLOR_CODE,
PRI_PROJ_V.RES_URL,
PRI_PROJ_V.RES_SCOPE_ID,
PRI_PROJ_V.RES_SCOPE_CODE,
PRI_PROJ_V.RES_SCOPE_NAME,
PRI_PROJ_V.RES_SCOPE_DESC,
PRI_PROJ_V.RES_TYPE_ID,
PRI_PROJ_V.RES_TYPE_CODE,
PRI_PROJ_V.RES_TYPE_NAME,
PRI_PROJ_V.RES_TYPE_DESC,
PRI_PROJ_V.RES_DESC,
PRI_PROJ_V.RES_DEMO_URL,
PRI_PROJ_V.CREATE_DATE RES_CREATE_DATE,
PRI_PROJ_V.CREATED_BY RES_CREATED_BY,
PRI_PROJ_V.LAST_MOD_DATE RES_LAST_MOD_DATE,
PRI_PROJ_V.LAST_MOD_BY RES_LAST_MOD_BY,
PRI_PROJ_V.PROJ_REFRESH_DATE RES_PROJ_REFRESH_DATE

FROM

--get the projects associated with each of the resources
PRI_PROJ
INNER JOIN PRI_DATA_SOURCES ON PRI_PROJ.DATA_SOURCE_ID = PRI_DATA_SOURCES.DATA_SOURCE_ID



--join the tagged projects to the maximum version numbers of the associated resources (exclude the projects that are the same since those don't need to be included in the list) to the project via TAG_PROJ_ID field
LEFT JOIN PRI_RES_TAG_MAX_VERS_V TAG_PROJ_VERS
ON PRI_PROJ.PROJ_ID = TAG_PROJ_VERS.TAG_PROJ_ID
AND TAG_PROJ_VERS.RES_PROJ_ID <> TAG_PROJ_VERS.TAG_PROJ_ID

--join the tagged resources and associated (implemented) projects from the given PRI_PROJ project
LEFT JOIN PRI_PROJ_V
ON PRI_PROJ_V.RES_ID = TAG_PROJ_VERS.RES_ID

--join the resources to the maximum version information for the corresponding resource (res and tag projects are equivalent so this is the maximum version number current defined for the project resource)
LEFT JOIN PRI_RES_TAG_MAX_VERS_V RES_PROJ_VERS
ON PRI_PROJ_V.RES_ID = RES_PROJ_VERS.RES_ID
AND RES_PROJ_VERS.RES_PROJ_ID = RES_PROJ_VERS.TAG_PROJ_ID


--LEFT JOIN PRI_PROJ TAG_PROJ
--ON TAG_PROJ.PROJ_ID = TAG_PROJ_VERS.TAG_PROJ_ID


ORDER BY PRI_PROJ.PROJ_NAME,
PRI_PROJ_V.RES_NAME,
PRI_PROJ_V.PROJ_NAME
;

COMMENT ON TABLE PRI_PROJ_RES_TAG_MAX_V IS 'Project Resource Implementations Maximum Versions (View)

This view returns all projects and associated implemented resources including highest version implemented and highest resource version as well as the resource''s project information';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.VC_PROJ_ID IS 'Unique numeric ID of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_DESC IS 'Description of the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.SSH_URL IS 'SSH URL for the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.HTTP_URL IS 'HTTP URL for the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.README_URL IS 'Readme URL for the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.AVATAR_URL IS 'Avatar URL for the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_CREATE_DTM IS 'The date/time the project was created';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_UPDATE_DTM IS 'The date/time the project was last updated';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private)';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_NAME_SPACE IS 'project name including the namespace prefix';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.DATA_SOURCE_ID IS 'Primary key for the project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.DATA_SOURCE_CODE IS 'Code for the given project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.DATA_SOURCE_NAME IS 'Name of the given project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.DATA_SOURCE_DESC IS 'Description for the given project''s Data Source';




COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.VC_OWNER_ID IS 'Unique numeric User ID of the project''s owner in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.VC_CREATOR_ID IS 'Unique numeric User ID of the project''s creator in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.VC_WEB_URL IS 'The web URL of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.VC_COMMIT_COUNT IS 'The total number of commits for the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.VC_REPO_SIZE IS 'The total repository size in bytes for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.FORMAT_VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system formatted as a string with a leading zero for values < 1';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_MAX_TAG_ID IS 'The TAG_ID value associated with the highest version number of the given resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_MAX_VERS_NUM IS 'The parsed version number for the maximum installed version of the given resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_TAG_ID IS 'The TAG_ID value associated with the highest version number of the project associated with the given resource (identified by TAG_PROJ_ID)';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM IS 'The parsed version number associated with the highest version number of the project associated with the given resource (identified by TAG_PROJ_ID)';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.TAG_MAX_VERS_YN IS 'Flag to indicate if the implemented resource version for the given project is the same as the maximum resource version (Y) or not (N).  This is used to identify implementations that are out of date';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VERS_STATUS IS 'Flag to indicate if the implemented resource version for the given project is the same as the maximum resource version (Current Version) or not (Update Available).  This is used to identify implementations that are out of date';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_ID IS 'Resource Project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VC_PROJ_ID IS 'Unique numeric ID of the resource project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_NAME IS 'Name of the resource project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_DESC IS 'Description of the resource project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_SSH_URL IS 'SSH URL for the resource project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_HTTP_URL IS 'HTTP URL for the resource project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_README_URL IS 'Readme URL for the resource project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_AVATAR_URL IS 'Avatar URL for the resource project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_CREATE_DTM IS 'The date/time the resource project was created';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_UPDATE_DTM IS 'The date/time the resource project was last updated';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_VISIBILITY IS 'The visibility for the resource project (public, internal, private)';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_NAME_SPACE IS 'resource project name including the namespace prefix';



COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_DATA_SOURCE_ID IS 'Primary key for the resource project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_DATA_SOURCE_CODE IS 'Code for the given resource project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_DATA_SOURCE_NAME IS 'Name of the given resource project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_DATA_SOURCE_DESC IS 'Description for the given resource project''s Data Source';




COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VC_OWNER_ID IS 'Unique numeric User ID of the resource project''s owner in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VC_CREATOR_ID IS 'Unique numeric User ID of the resource project''s creator in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VC_WEB_URL IS 'The web URL of the resource project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the resource project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VC_COMMIT_COUNT IS 'The total number of commits for the resource project in the given version control system';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VC_REPO_SIZE IS 'The total repository size in bytes for the resource project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_VC_REPO_SIZE_MB IS 'The total repository size in MB for the resource project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_FORMAT_VC_REPO_SIZE_MB IS 'The total repository size in MB for the resource project in the given version control system formatted as a string with a leading zero for values < 1';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_CATEGORY IS 'The resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_TAG_CONV IS 'Tag Naming convention used to identify the given project resource''s version.  The suffix is required to be a series of period-delimited numbers (e.g. for a naming convention of db_module_packager_v the tag value of db_module_packager_v1.13.4 is valid)';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS 'The name of the project resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_COLOR_CODE IS 'The color code for the project resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_URL IS 'The URL for the project resource (this is blank when the repository URL is the same as the resource URL)';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_SCOPE_ID IS 'Foreign key reference to the resource scope';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_SCOPE_CODE IS 'Code for the given Resource Scope';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_SCOPE_NAME IS 'Name of the given Resource Scope';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_SCOPE_DESC IS 'Description for the given Resource Scope';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_TYPE_ID IS 'Foreign key reference to the resource type';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_TYPE_CODE IS 'Code for the given Resource Type';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_TYPE_NAME IS 'Name of the given Resource Type';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_TYPE_DESC IS 'Description for the given Resource Type';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_DESC IS 'The description for the project resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_CREATE_DATE IS 'The date the resource project record was created in the database';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_CREATED_BY IS 'The Oracle username of the person that created the resource project record in the database';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_LAST_MOD_DATE IS 'The last date on which any of the data in the resource project record was changed';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the resource project record';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_REFRESH_DATE IS 'The date of the last time the resource project information was refreshed in the database';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.CREATE_DATE IS 'The date the project record was created in the database';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.CREATED_BY IS 'The Oracle username of the person that created the project record in the database';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.LAST_MOD_DATE IS 'The last date on which any of the data in the project record was changed';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the project record';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_REFRESH_DATE IS 'The date of the last time the project information was refreshed in the database';















--summary view for all projects and associated (implemented) resources
CREATE OR REPLACE VIEW
PRI_PROJ_RES_TAG_MAX_SUM_V
AS
SELECT
PRI_PROJ_RES_TAG_MAX_V.PROJ_ID,
PRI_PROJ_RES_TAG_MAX_V.PROJ_NAME,
ASSOC_RES.RES_NAME_CD_LIST,
ASSOC_RES.RES_NAME_BR_LIST,
ASSOC_RES.RES_NAME_LINK_BR_LIST,
ASSOC_RES.NUM_RES,

SUM(CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'Y' THEN 1 WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'N' THEN 0 ELSE NULL END) CURR_VERS_COUNT,


SUM(CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'N' THEN 1 WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'Y' THEN 0 ELSE NULL END) OLD_VERS_COUNT,


SUM (CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM IS NOT NULL THEN 1 ELSE NULL END) TOTAL_IMPL_RES,




LISTAGG((CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL THEN (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '(*CV) ' ELSE '(*UA) ' END)|| PRI_PROJ_RES_TAG_MAX_V.RES_NAME||' (v'||PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), ', ') WITHIN GROUP (order by PRI_PROJ_RES_TAG_MAX_V.RES_NAME) IMPL_RES_CD_LIST,
LISTAGG((CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL THEN (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '(*CV) ' ELSE '(*UA) ' END)|| PRI_PROJ_RES_TAG_MAX_V.RES_NAME||' (v'||PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_PROJ_RES_TAG_MAX_V.RES_NAME) IMPL_RES_BR_LIST,
LISTAGG((CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL THEN '<a href="./view_resource.php?RES_ID='||PRI_PROJ_RES_TAG_MAX_V.RES_ID||'">'||(CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '(*CV) ' ELSE '(*UA) ' END)|| PRI_PROJ_RES_TAG_MAX_V.RES_NAME||' (v'||PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')</a>' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_PROJ_RES_TAG_MAX_V.RES_NAME) IMPL_RES_LINK_BR_LIST

FROM PRI_PROJ_RES_TAG_MAX_V
LEFT JOIN
(
SELECT
PRI_PROJ_RES.PROJ_ID,
LISTAGG (RES_NAME|| ' (v'||MAX_VERS_NUM||')', ', ') WITHIN GROUP (order by RES_NAME) RES_NAME_CD_LIST,
LISTAGG (RES_NAME|| ' (v'||MAX_VERS_NUM||')', '<BR>') WITHIN GROUP (order by RES_NAME) RES_NAME_BR_LIST,
LISTAGG ('<a href="./view_resource.php?RES_ID='||PRI_PROJ_RES.RES_ID||'">'||RES_NAME|| ' (v'||MAX_VERS_NUM||')</a>', '<BR>') WITHIN GROUP (order by RES_NAME) RES_NAME_LINK_BR_LIST,
COUNT(*) NUM_RES

FROM
PRI_PROJ_RES INNER JOIN

--join all of the associated resource/tag versions for the given project
PRI_RES_TAG_MAX_VERS_V ON
PRI_PROJ_RES.RES_ID = PRI_RES_TAG_MAX_VERS_V.RES_ID
--get the maximum version of the resource only (resource project is the same as the tag project)
AND PRI_RES_TAG_MAX_VERS_V.RES_PROJ_ID = PRI_RES_TAG_MAX_VERS_V.TAG_PROJ_ID
--join on the project ID for the resource
AND PRI_RES_TAG_MAX_VERS_V.RES_PROJ_ID = PRI_PROJ_RES.PROJ_ID

GROUP BY PRI_PROJ_RES.PROJ_ID
) ASSOC_RES
ON
ASSOC_RES.PROJ_ID = PRI_PROJ_RES_TAG_MAX_V.PROJ_ID

GROUP BY
PRI_PROJ_RES_TAG_MAX_V.PROJ_ID,
PRI_PROJ_RES_TAG_MAX_V.PROJ_NAME,
ASSOC_RES.RES_NAME_CD_LIST,
ASSOC_RES.RES_NAME_BR_LIST,
ASSOC_RES.RES_NAME_LINK_BR_LIST,
ASSOC_RES.NUM_RES;


COMMENT ON TABLE PRI_PROJ_RES_TAG_MAX_SUM_V IS 'Project Resource Implementations Maximum Versions Summary (View)

This view returns all projects and summary information of all implemented resources including highest version implemented';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.CURR_VERS_COUNT IS 'The number of implemented resources that have been implemented by the project that are the same as the current version of the resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.OLD_VERS_COUNT IS 'The number of implemented resources that have been implemented by the project that are not the same as the current version of the resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.TOTAL_IMPL_RES IS 'The total number of project resources that have been implemented in the given project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.IMPL_RES_CD_LIST IS 'A comma-delimited list of project resources and associated highest version number that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.IMPL_RES_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.IMPL_RES_LINK_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number in a formatted hyperlink with a relative path to the given Resource Inventory App resource that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';



COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.RES_NAME_CD_LIST IS 'A comma-delimited list of project resources and associated highest version number that are associated with the project';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.RES_NAME_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number that are associated with the project';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.RES_NAME_LINK_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number in a formatted hyperlink with a relative path to the given Resource Inventory App resource that are associated with the project';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.NUM_RES IS 'The number of associated resources with the project';




--summary view for all projects and associated (implemented) resources
CREATE OR REPLACE VIEW
PRI_PROJ_RES_TAG_MAX_SUM_ALL_V
AS
SELECT
PRI_PROJ_RES_TAG_MAX_SUM_V.PROJ_ID,
PRI_PROJ_RES_TAG_MAX_SUM_V.PROJ_NAME,
PRI_PROJ_RES_TAG_MAX_SUM_V.RES_NAME_CD_LIST,
PRI_PROJ_RES_TAG_MAX_SUM_V.RES_NAME_BR_LIST,
PRI_PROJ_RES_TAG_MAX_SUM_V.RES_NAME_LINK_BR_LIST,
PRI_PROJ_RES_TAG_MAX_SUM_V.NUM_RES,
PRI_PROJ_RES_TAG_MAX_SUM_V.CURR_VERS_COUNT,
PRI_PROJ_RES_TAG_MAX_SUM_V.OLD_VERS_COUNT,
PRI_PROJ_RES_TAG_MAX_SUM_V.TOTAL_IMPL_RES,
PRI_PROJ_RES_TAG_MAX_SUM_V.IMPL_RES_CD_LIST,
PRI_PROJ_RES_TAG_MAX_SUM_V.IMPL_RES_BR_LIST,
PRI_PROJ_RES_TAG_MAX_SUM_V.IMPL_RES_LINK_BR_LIST,
PRI_PROJ.VC_PROJ_ID,
PRI_PROJ.PROJ_DESC,
PRI_PROJ.SSH_URL,
PRI_PROJ.HTTP_URL,
PRI_PROJ.README_URL,
PRI_PROJ.AVATAR_URL,
PRI_PROJ.PROJ_CREATE_DTM,
PRI_PROJ.PROJ_UPDATE_DTM,
PRI_PROJ.PROJ_VISIBILITY,
PRI_PROJ.PROJ_NAME_SPACE,

PRI_DATA_SOURCES.DATA_SOURCE_ID,
PRI_DATA_SOURCES.DATA_SOURCE_CODE,
PRI_DATA_SOURCES.DATA_SOURCE_NAME,
PRI_DATA_SOURCES.DATA_SOURCE_DESC,


PRI_PROJ.VC_OWNER_ID,
OWNER.USER_ID OWNER_USER_ID,
OWNER.USERNAME OWNER_USERNAME,
OWNER.USER_NAME OWNER_USER_NAME,
OWNER.USER_EMAIL OWNER_USER_EMAIL,
OWNER.AVATAR_URL OWNER_AVATAR_URL,
OWNER.WEB_URL OWNER_WEB_URL,

PRI_PROJ.VC_CREATOR_ID,
CREATOR.USER_ID CREATOR_USER_ID,
CREATOR.USERNAME CREATOR_USERNAME,
CREATOR.USER_NAME CREATOR_USER_NAME,
CREATOR.USER_EMAIL CREATOR_USER_EMAIL,
CREATOR.AVATAR_URL CREATOR_AVATAR_URL,
CREATOR.WEB_URL CREATOR_WEB_URL,


PRI_PROJ.VC_WEB_URL,
PRI_PROJ.VC_OPEN_ISSUES_COUNT,
PRI_PROJ.VC_COMMIT_COUNT,
PRI_PROJ.VC_REPO_SIZE,
ROUND((PRI_PROJ.VC_REPO_SIZE / 1024) / 1024, 2) VC_REPO_SIZE_MB,
TRIM(TO_CHAR(ROUND((PRI_PROJ.VC_REPO_SIZE / 1024) / 1024, 2), '999,990.99')) FORMAT_VC_REPO_SIZE_MB,
PRI_PROJ.CREATE_DATE,
PRI_PROJ.CREATED_BY,
PRI_PROJ.LAST_MOD_DATE,
PRI_PROJ.LAST_MOD_BY,
NVL(PRI_PROJ.LAST_MOD_DATE, PRI_PROJ.CREATE_DATE) PROJ_REFRESH_DATE


FROM
PRI_PROJ_RES_TAG_MAX_SUM_V
INNER JOIN
PRI_PROJ ON PRI_PROJ_RES_TAG_MAX_SUM_V.PROJ_ID = PRI_PROJ.PROJ_ID
INNER JOIN PRI_DATA_SOURCES ON PRI_PROJ.DATA_SOURCE_ID = PRI_DATA_SOURCES.DATA_SOURCE_ID

LEFT JOIN PRI_VC_USERS_V CREATOR ON PRI_PROJ.VC_CREATOR_ID = CREATOR.VC_USER_ID AND CREATOR.DATA_SOURCE_ID = PRI_PROJ.DATA_SOURCE_ID
LEFT JOIN PRI_VC_USERS_V OWNER ON PRI_PROJ.VC_OWNER_ID = OWNER.VC_USER_ID
AND OWNER.DATA_SOURCE_ID = PRI_PROJ.DATA_SOURCE_ID
;


COMMENT ON TABLE PRI_PROJ_RES_TAG_MAX_SUM_ALL_V IS 'Project Resource Implementations Maximum Versions Summary with Detailed Project Information (View)

This view returns all projects and summary information of all implemented resources including highest version implemented as well as detailed project information';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.RES_NAME_CD_LIST IS 'A comma-delimited list of project resources and associated highest version number that are associated with the project';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.RES_NAME_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number that are associated with the project';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.RES_NAME_LINK_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number in a formatted hyperlink with a relative path to the given Resource Inventory App resource that are associated with the project';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.NUM_RES IS 'The number of associated resources with the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CURR_VERS_COUNT IS 'The number of implemented resources that have been implemented by the project that are the same as the current version of the resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.OLD_VERS_COUNT IS 'The number of implemented resources that have been implemented by the project that are not the same as the current version of the resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.TOTAL_IMPL_RES IS 'The total number of project resources that have been implemented in the given project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.IMPL_RES_CD_LIST IS 'A comma-delimited list of project resources and associated highest version number that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.VC_PROJ_ID IS 'Unique numeric ID of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_DESC IS 'Description of the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.SSH_URL IS 'SSH URL for the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.HTTP_URL IS 'HTTP URL for the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.README_URL IS 'Readme URL for the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.AVATAR_URL IS 'Avatar URL for the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_CREATE_DTM IS 'The date/time the project was created';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_UPDATE_DTM IS 'The date/time the project was last updated';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private)';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_NAME_SPACE IS 'project name including the namespace prefix';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.DATA_SOURCE_ID IS 'Primary key for the project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.DATA_SOURCE_CODE IS 'Code for the given project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.DATA_SOURCE_NAME IS 'Name of the given project''s Data Source';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.DATA_SOURCE_DESC IS 'Description for the given project''s Data Source';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.IMPL_RES_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.IMPL_RES_LINK_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number in a formatted hyperlink with a relative path to the given Resource Inventory App resource that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.VC_OWNER_ID IS 'Unique numeric User ID of the project''s owner in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.VC_CREATOR_ID IS 'Unique numeric User ID of the project''s creator in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.VC_WEB_URL IS 'The web URL of the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.VC_COMMIT_COUNT IS 'The total number of commits for the project in the given version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.VC_REPO_SIZE IS 'The total repository size in bytes for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.FORMAT_VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system formatted as a string with a leading zero for values < 1';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.OWNER_USER_ID IS 'The Project Owner''s User ID for the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.OWNER_USERNAME IS 'Login username for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.OWNER_USER_NAME IS 'Name of the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.OWNER_USER_EMAIL IS 'Email for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.OWNER_AVATAR_URL IS 'Avatar URL for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.OWNER_WEB_URL IS 'Web URL for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CREATOR_USER_ID IS 'The Project Creator''s User ID for the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CREATOR_USERNAME IS 'Login username for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CREATOR_USER_NAME IS 'Name of the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CREATOR_USER_EMAIL IS 'Email for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CREATOR_AVATAR_URL IS 'Avatar URL for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CREATOR_WEB_URL IS 'Web URL for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CREATE_DATE IS 'The date the project record was created in the database';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.CREATED_BY IS 'The Oracle username of the person that created the project record in the database';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.LAST_MOD_DATE IS 'The last date on which any of the data in the project record was changed';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the project record';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_REFRESH_DATE IS 'The date of the last time the project information was refreshed in the database';


--Detailed query to show all associations of each resource and the highest version of each module (need to join it to the max version information twice but I think it should be able to filter on both times based on the PROJ_ID values matching or not.) - the view should be queried once and the result sets reused if the DB engine works properly
CREATE OR REPLACE VIEW PRI_RES_PROJ_TAG_MAX_V

AS
SELECT
PRI_PROJ_V.PROJ_ID,
PRI_PROJ_V.VC_PROJ_ID,
PRI_PROJ_V.PROJ_NAME,
PRI_PROJ_V.PROJ_DESC,
PRI_PROJ_V.SSH_URL,
PRI_PROJ_V.HTTP_URL,
PRI_PROJ_V.README_URL,
PRI_PROJ_V.AVATAR_URL,
PRI_PROJ_V.PROJ_CREATE_DTM,
PRI_PROJ_V.PROJ_UPDATE_DTM,
PRI_PROJ_V.PROJ_VISIBILITY,
PRI_PROJ_V.PROJ_NAME_SPACE,

PRI_PROJ_V.DATA_SOURCE_ID,
PRI_PROJ_V.DATA_SOURCE_CODE,
PRI_PROJ_V.DATA_SOURCE_NAME,
PRI_PROJ_V.DATA_SOURCE_DESC,


PRI_PROJ_V.VC_OWNER_ID,
PRI_PROJ_V.VC_CREATOR_ID,
PRI_PROJ_V.VC_WEB_URL,
PRI_PROJ_V.VC_OPEN_ISSUES_COUNT,
PRI_PROJ_V.VC_COMMIT_COUNT,
PRI_PROJ_V.VC_REPO_SIZE,
PRI_PROJ_V.VC_REPO_SIZE_MB,
PRI_PROJ_V.FORMAT_VC_REPO_SIZE_MB,



PRI_PROJ_V.RES_ID,
PRI_PROJ_V.RES_CATEGORY,
PRI_PROJ_V.RES_TAG_CONV,
PRI_PROJ_V.RES_NAME,
PRI_PROJ_V.RES_COLOR_CODE,
PRI_PROJ_V.RES_URL,
PRI_PROJ_V.RES_SCOPE_ID,
PRI_PROJ_V.RES_SCOPE_CODE,
PRI_PROJ_V.RES_SCOPE_NAME,
PRI_PROJ_V.RES_SCOPE_DESC,
PRI_PROJ_V.RES_TYPE_ID,
PRI_PROJ_V.RES_TYPE_CODE,
PRI_PROJ_V.RES_TYPE_NAME,
PRI_PROJ_V.RES_TYPE_DESC,
PRI_PROJ_V.RES_DESC,
PRI_PROJ_V.RES_DEMO_URL,
PRI_PROJ_V.CREATE_DATE,
PRI_PROJ_V.CREATED_BY,
PRI_PROJ_V.LAST_MOD_DATE,
PRI_PROJ_V.LAST_MOD_BY,
PRI_PROJ_V.PROJ_REFRESH_DATE,

RES_PROJ_VERS.MAX_TAG_ID RES_MAX_TAG_ID,
RES_PROJ_VERS.MAX_VERS_NUM RES_MAX_VERS_NUM,
TAG_PROJ_VERS.MAX_TAG_ID TAG_PROJ_MAX_TAG_ID,
TAG_PROJ_VERS.MAX_VERS_NUM TAG_PROJ_MAX_VERS_NUM,
(CASE WHEN RES_PROJ_VERS.MAX_VERS_NUM = TAG_PROJ_VERS.MAX_VERS_NUM THEN 'Y' WHEN RES_PROJ_VERS.MAX_VERS_NUM IS NULL OR TAG_PROJ_VERS.MAX_VERS_NUM IS NULL THEN NULL ELSE 'N' END) TAG_MAX_VERS_YN,
(CASE WHEN RES_PROJ_VERS.MAX_VERS_NUM = TAG_PROJ_VERS.MAX_VERS_NUM THEN 'Current Version' WHEN RES_PROJ_VERS.MAX_VERS_NUM IS NULL OR TAG_PROJ_VERS.MAX_VERS_NUM IS NULL THEN NULL ELSE 'Update Available' END) TAG_VERS_STATUS,
TAG_PROJ.PROJ_ID TAG_PROJ_ID,
TAG_PROJ.VC_PROJ_ID TAG_VC_PROJ_ID,
TAG_PROJ.PROJ_NAME TAG_PROJ_NAME,
TAG_PROJ.PROJ_DESC TAG_PROJ_DESC,
TAG_PROJ.SSH_URL TAG_SSH_URL,
TAG_PROJ.HTTP_URL TAG_HTTP_URL,
TAG_PROJ.README_URL TAG_README_URL,
TAG_PROJ.AVATAR_URL TAG_AVATAR_URL,
TAG_PROJ.PROJ_CREATE_DTM TAG_PROJ_CREATE_DTM,
TAG_PROJ.PROJ_UPDATE_DTM TAG_PROJ_UPDATE_DTM,
TAG_PROJ.PROJ_VISIBILITY TAG_PROJ_VISIBILITY,
TAG_PROJ.PROJ_NAME_SPACE TAG_PROJ_NAME_SPACE,

PRI_DATA_SOURCES.DATA_SOURCE_ID TAG_DATA_SOURCE_ID,
PRI_DATA_SOURCES.DATA_SOURCE_CODE TAG_DATA_SOURCE_CODE,
PRI_DATA_SOURCES.DATA_SOURCE_NAME TAG_DATA_SOURCE_NAME,
PRI_DATA_SOURCES.DATA_SOURCE_DESC TAG_DATA_SOURCE_DESC,


TAG_PROJ.VC_OWNER_ID TAG_VC_OWNER_ID,
TAG_PROJ.VC_CREATOR_ID TAG_VC_CREATOR_ID,
TAG_PROJ.VC_WEB_URL TAG_VC_WEB_URL,
TAG_PROJ.VC_OPEN_ISSUES_COUNT TAG_VC_OPEN_ISSUES_COUNT,
TAG_PROJ.VC_COMMIT_COUNT TAG_VC_COMMIT_COUNT,
TAG_PROJ.VC_REPO_SIZE TAG_VC_REPO_SIZE,
ROUND((TAG_PROJ.VC_REPO_SIZE / 1024) / 1024, 2) TAG_VC_REPO_SIZE_MB,
TRIM(TO_CHAR(ROUND((TAG_PROJ.VC_REPO_SIZE / 1024) / 1024, 2), '999,990.99')) TAG_FORMAT_VC_REPO_SIZE_MB,

TAG_PROJ.CREATE_DATE TAG_CREATE_DATE,
TAG_PROJ.CREATED_BY TAG_CREATED_BY,
TAG_PROJ.LAST_MOD_DATE TAG_LAST_MOD_DATE,
TAG_PROJ.LAST_MOD_BY TAG_LAST_MOD_BY,
NVL(TAG_PROJ.LAST_MOD_DATE, TAG_PROJ.CREATE_DATE) TAG_PROJ_REFRESH_DATE





FROM

--get the projects associated with each of the resources
PRI_PROJ_V
--join the resources to the maximum version information for the corresponding resource (res and tag projects are equivalent so this is the maximum version number current defined for the project resource) - show only the projects with resources
LEFT JOIN PRI_RES_TAG_MAX_VERS_V RES_PROJ_VERS
ON PRI_PROJ_V.RES_ID = RES_PROJ_VERS.RES_ID
AND RES_PROJ_VERS.RES_PROJ_ID = RES_PROJ_VERS.TAG_PROJ_ID

--join the tagged projects to the maximum version numbers of the associated resources (exclude the projects that are the same since those don't need to be included in the list)
LEFT JOIN PRI_RES_TAG_MAX_VERS_V TAG_PROJ_VERS
ON PRI_PROJ_V.RES_ID = TAG_PROJ_VERS.RES_ID
AND TAG_PROJ_VERS.RES_PROJ_ID <> TAG_PROJ_VERS.TAG_PROJ_ID

--join all the projects that tag the given resource
LEFT JOIN PRI_PROJ TAG_PROJ
ON TAG_PROJ.PROJ_ID = TAG_PROJ_VERS.TAG_PROJ_ID
LEFT JOIN PRI_DATA_SOURCES ON TAG_PROJ.DATA_SOURCE_ID = PRI_DATA_SOURCES.DATA_SOURCE_ID

WHERE PRI_PROJ_V.RES_ID IS NOT NULL

ORDER BY PRI_PROJ_V.PROJ_NAME,
PRI_PROJ_V.RES_NAME,
TAG_PROJ.PROJ_NAME
;
COMMENT ON TABLE PRI_RES_PROJ_TAG_MAX_V IS 'Resource and Implemented Project Maximum Versions (View)

This view returns all project resources (including highest version) and all associated projects that tag the resource (as implemented) including the highest version number for the associated tagged project.';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.VC_PROJ_ID IS 'Unique numeric ID of the project in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_DESC IS 'Description of the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.SSH_URL IS 'SSH URL for the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.HTTP_URL IS 'HTTP URL for the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.README_URL IS 'Readme URL for the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.AVATAR_URL IS 'Avatar URL for the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_CREATE_DTM IS 'The date/time the project was created';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_UPDATE_DTM IS 'The date/time the project was last updated';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private)';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_NAME_SPACE IS 'project name including the namespace prefix';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.DATA_SOURCE_ID IS 'Primary key for the project''s Data Source';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.DATA_SOURCE_CODE IS 'Code for the given project''s Data Source';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.DATA_SOURCE_NAME IS 'Name of the given project''s Data Source';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.DATA_SOURCE_DESC IS 'Description for the given project''s Data Source';



COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.VC_OWNER_ID IS 'Unique numeric User ID of the project''s owner in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.VC_CREATOR_ID IS 'Unique numeric User ID of the project''s creator in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.VC_WEB_URL IS 'The web URL of the project in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the project in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.VC_COMMIT_COUNT IS 'The total number of commits for the project in the given version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.VC_REPO_SIZE IS 'The total repository size in bytes for the project in the given version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.FORMAT_VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system formatted as a string with a leading zero for values < 1';





COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_CATEGORY IS 'The resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_TAG_CONV IS 'Tag Naming convention used to identify the given project resource''s version.  The suffix is required to be a series of period-delimited numbers (e.g. for a naming convention of db_module_packager_v the tag value of db_module_packager_v1.13.4 is valid)';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS 'The name of the project resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_COLOR_CODE IS 'The color code for the project resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_URL IS 'The URL for the project resource (this is blank when the repository URL is the same as the resource URL)';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_SCOPE_ID IS 'Foreign key reference to the resource scope';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_SCOPE_CODE IS 'Code for the given Resource Scope';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_SCOPE_NAME IS 'Name of the given Resource Scope';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_SCOPE_DESC IS 'Description for the given Resource Scope';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_TYPE_ID IS 'Foreign key reference to the resource type';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_TYPE_CODE IS 'Code for the given Resource Type';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_TYPE_NAME IS 'Name of the given Resource Type';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_TYPE_DESC IS 'Description for the given Resource Type';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_MAX_TAG_ID IS 'The TAG_ID value associated with the highest version number of the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_MAX_VERS_NUM IS 'The parsed version number for the maximum installed version of the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_TAG_ID IS 'The TAG_ID value associated with the highest version number of the project associated with the given resource (identified by TAG_PROJ_ID)';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM IS 'The parsed version number associated with the highest version number of the project associated with the given resource (identified by TAG_PROJ_ID)';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_MAX_VERS_YN IS 'Flag to indicate if the resource''s maximum version is the same as the maximum version implemented on the associated project (Y) or not (N).  This is used to identify implementations that are out of date';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VERS_STATUS IS 'Flag to indicate if the resource''s maximum version is the same as the maximum version implemented on the associated project (Current Version) or not (Update Available).  This is used to identify implementations that are out of date';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_ID IS 'Primary key for the PRI_PROJ table for the project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VC_PROJ_ID IS 'Unique numeric ID of the project in the given version control system for the project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS 'Name of the project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_DESC IS 'Description of the project project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_SSH_URL IS 'SSH URL for the project project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_HTTP_URL IS 'HTTP URL for the project project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_README_URL IS 'Readme URL for the project project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_AVATAR_URL IS 'Avatar URL for the project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_CREATE_DTM IS 'The date/time the project associated with the given resource was created';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_UPDATE_DTM IS 'The date/time the project associated with the given resource was last updated';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private) associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME_SPACE IS 'project name including the namespace prefix associated with the given resource';



COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_DATA_SOURCE_ID IS 'Primary key for the Data Source for the project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_DATA_SOURCE_CODE IS 'Code for the Data Source for the project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_DATA_SOURCE_NAME IS 'Name of the Data Source for the project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_DATA_SOURCE_DESC IS 'Description for the Data Source for the project associated with the given resource';



COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VC_OWNER_ID IS 'Unique numeric User ID of the project''s owner associated with the given resource in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VC_CREATOR_ID IS 'Unique numeric User ID of the project''s creator associated with the given resource in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VC_WEB_URL IS 'The web URL of the project associated with the given resource in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the project associated with the given resource in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VC_COMMIT_COUNT IS 'The total number of commits for the project associated with the given resource in the given version control system';



COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VC_REPO_SIZE IS 'The total repository size in bytes for the project associated with the given resource in the given version control system';


COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_VC_REPO_SIZE_MB IS 'The total repository size in MB for the project associated with the given resource in the given version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_FORMAT_VC_REPO_SIZE_MB IS 'The total repository size in MB for the project associated with the given resource in the given version control system formatted as a string with a leading zero for values < 1';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_DESC IS 'The description for the project resource';


COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.CREATE_DATE IS 'The date the project record was created in the database';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.CREATED_BY IS 'The Oracle username of the person that created the project record in the database';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.LAST_MOD_DATE IS 'The last date on which any of the data in the project record was changed';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the project record';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_REFRESH_DATE IS 'The date of the last time the project information was refreshed in the database';


COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_CREATE_DATE IS 'The date the project associated with the given resource record was created in the database';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_CREATED_BY IS 'The Oracle username of the person that created the project associated with the given resource record in the database';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_LAST_MOD_DATE IS 'The last date on which any of the data in the project associated with the given resource record was changed';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the project associated with the given resource  record';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_REFRESH_DATE IS 'The date of the last time the project information associated with the given resource was refreshed in the database';


CREATE OR REPLACE VIEW
PRI_RES_PROJ_TAG_MAX_SUM_V
AS
SELECT
PRI_RES_PROJ_TAG_MAX_V.PROJ_ID,
PRI_RES_PROJ_TAG_MAX_V.PROJ_NAME,
PRI_RES_PROJ_TAG_MAX_V.RES_ID,
PRI_RES_PROJ_TAG_MAX_V.RES_NAME,
PRI_RES_PROJ_TAG_MAX_V.RES_MAX_VERS_NUM,
SUM(CASE WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'Y' THEN 1 WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'N' THEN 0 ELSE NULL END) CURR_VERS_COUNT,


SUM(CASE WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'N' THEN 1 WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'Y' THEN 0 ELSE NULL END) OLD_VERS_COUNT,

SUM (CASE WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND  PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM IS NOT NULL THEN 1 ELSE NULL END) TOTAL_IMPL_PROJ,


LISTAGG((CASE WHEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS NOT NULL THEN (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '(*CV) ' ELSE '(*UA) ' END)||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME||' (v'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), ', ') WITHIN GROUP (order by PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME) ASSOC_PROJ_CD_LIST,
LISTAGG((CASE WHEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS NOT NULL THEN (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '(*CV) ' ELSE '(*UA) ' END)||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME||' (v'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME) ASSOC_PROJ_BR_LIST,
LISTAGG((CASE WHEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS NOT NULL THEN '<a href="./view_project.php?PROJ_ID='||PRI_RES_PROJ_TAG_MAX_V.PROJ_ID||'">'||(CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '(*CV) ' ELSE '(*UA) ' END)||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME||' (v'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')</a>' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME) ASSOC_PROJ_LINK_BR_LIST



FROM PRI_RES_PROJ_TAG_MAX_V
GROUP BY
PRI_RES_PROJ_TAG_MAX_V.PROJ_ID,
PRI_RES_PROJ_TAG_MAX_V.PROJ_NAME,
PRI_RES_PROJ_TAG_MAX_V.PROJ_VISIBILITY,
PRI_RES_PROJ_TAG_MAX_V.RES_NAME,
PRI_RES_PROJ_TAG_MAX_V.RES_ID,
PRI_RES_PROJ_TAG_MAX_V.RES_MAX_VERS_NUM,
PRI_RES_PROJ_TAG_MAX_V.AVATAR_URL
;
COMMENT ON TABLE PRI_RES_PROJ_TAG_MAX_SUM_V IS 'Resource and Installed Project Maximum Versions Summary (View)

This view returns the projects and associated resource (including highest version) and a summary of all associated projects that tag the resource (as implemented).';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.PROJ_NAME IS 'Name of the project';


COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.RES_NAME IS 'The name of the project resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.RES_MAX_VERS_NUM IS 'The parsed version number for the maximum installed version of the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.CURR_VERS_COUNT IS 'The number of projects that have implemented the given resource that are the same as the current version';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.OLD_VERS_COUNT IS 'The number of projects that have implemented the given resource that are not the same as the current version';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.TOTAL_IMPL_PROJ IS 'The total number of projects that have implemented the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.ASSOC_PROJ_CD_LIST IS 'A comma-delimited list of projects and associated highest version number that have implemented the given resource.  If the current version implemented is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.ASSOC_PROJ_BR_LIST IS 'A web line-break-delimited (<BR>) list of projects and associated highest version number that have implemented the given resource.  If the current version implemented is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.ASSOC_PROJ_LINK_BR_LIST IS 'A web line-break-delimited (<BR>) list of projects and associated highest version number in a formatted hyperlink with a relative path to the given Resource Inventory App project that has implemented the given resource.  If the current version implemented is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';

CREATE OR REPLACE VIEW
PRI_RES_PROJ_TAG_MAX_SUM_ALL_V

AS
SELECT
PRI_RES_PROJ_TAG_MAX_SUM_V.PROJ_ID,
PRI_RES_PROJ_TAG_MAX_SUM_V.PROJ_NAME,
PRI_RES_PROJ_TAG_MAX_SUM_V.RES_ID,
PRI_RES_PROJ_TAG_MAX_SUM_V.RES_NAME,
PRI_RES_PROJ_TAG_MAX_SUM_V.RES_MAX_VERS_NUM,
PRI_RES_PROJ_TAG_MAX_SUM_V.CURR_VERS_COUNT,
PRI_RES_PROJ_TAG_MAX_SUM_V.OLD_VERS_COUNT,
PRI_RES_PROJ_TAG_MAX_SUM_V.TOTAL_IMPL_PROJ,
PRI_RES_PROJ_TAG_MAX_SUM_V.ASSOC_PROJ_CD_LIST,
PRI_RES_PROJ_TAG_MAX_SUM_V.ASSOC_PROJ_BR_LIST,
PRI_RES_PROJ_TAG_MAX_SUM_V.ASSOC_PROJ_LINK_BR_LIST,
PRI_PROJ_V.VC_PROJ_ID,
PRI_PROJ_V.PROJ_DESC,
PRI_PROJ_V.SSH_URL,
PRI_PROJ_V.HTTP_URL,
PRI_PROJ_V.README_URL,
PRI_PROJ_V.AVATAR_URL,
PRI_PROJ_V.PROJ_CREATE_DTM,
PRI_PROJ_V.PROJ_UPDATE_DTM,
PRI_PROJ_V.PROJ_VISIBILITY,
PRI_PROJ_V.PROJ_NAME_SPACE,

PRI_PROJ_V.DATA_SOURCE_ID,
PRI_PROJ_V.DATA_SOURCE_CODE,
PRI_PROJ_V.DATA_SOURCE_NAME,
PRI_PROJ_V.DATA_SOURCE_DESC,


PRI_PROJ_V.VC_OWNER_ID,
PRI_PROJ_V.OWNER_USER_ID,
PRI_PROJ_V.OWNER_USERNAME,
PRI_PROJ_V.OWNER_USER_NAME,
PRI_PROJ_V.OWNER_USER_EMAIL,
PRI_PROJ_V.OWNER_AVATAR_URL,
PRI_PROJ_V.OWNER_WEB_URL,

PRI_PROJ_V.VC_CREATOR_ID,
PRI_PROJ_V.CREATOR_USER_ID,
PRI_PROJ_V.CREATOR_USERNAME,
PRI_PROJ_V.CREATOR_USER_NAME,
PRI_PROJ_V.CREATOR_USER_EMAIL,
PRI_PROJ_V.CREATOR_AVATAR_URL,
PRI_PROJ_V.CREATOR_WEB_URL,

PRI_PROJ_V.VC_WEB_URL,
PRI_PROJ_V.VC_OPEN_ISSUES_COUNT,
PRI_PROJ_V.VC_COMMIT_COUNT,
PRI_PROJ_V.VC_REPO_SIZE,
PRI_PROJ_V.VC_REPO_SIZE_MB,
PRI_PROJ_V.FORMAT_VC_REPO_SIZE_MB,

PRI_PROJ_V.RES_CATEGORY,
PRI_PROJ_V.RES_TAG_CONV,
PRI_PROJ_V.RES_COLOR_CODE,
PRI_PROJ_V.RES_URL,
PRI_PROJ_V.RES_SCOPE_ID,
PRI_PROJ_V.RES_SCOPE_CODE,
PRI_PROJ_V.RES_SCOPE_NAME,
PRI_PROJ_V.RES_SCOPE_DESC,
PRI_PROJ_V.RES_TYPE_ID,
PRI_PROJ_V.RES_TYPE_CODE,
PRI_PROJ_V.RES_TYPE_NAME,
PRI_PROJ_V.RES_TYPE_DESC,
PRI_PROJ_V.RES_DESC,
PRI_PROJ_V.RES_DEMO_URL,
PRI_PROJ_V.CREATE_DATE,
PRI_PROJ_V.CREATED_BY,
PRI_PROJ_V.LAST_MOD_DATE,
PRI_PROJ_V.LAST_MOD_BY,
PRI_PROJ_V.PROJ_REFRESH_DATE


FROM
PRI_RES_PROJ_TAG_MAX_SUM_V INNER JOIN
PRI_PROJ_V ON PRI_RES_PROJ_TAG_MAX_SUM_V.RES_ID = PRI_PROJ_V.RES_ID
ORDER BY PRI_RES_PROJ_TAG_MAX_SUM_V.PROJ_NAME,
PRI_RES_PROJ_TAG_MAX_SUM_V.RES_NAME
;

COMMENT ON TABLE PRI_RES_PROJ_TAG_MAX_SUM_ALL_V IS 'Resource and Installed Project Maximum Versions Summary with Detailed Resource Information (View)

This view returns the projects and associated resource (including highest version) and a summary of all associated projects that tag the resource (as implemented) as well as detailed resource and related project information';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_NAME IS 'The name of the project resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_MAX_VERS_NUM IS 'The parsed version number for the maximum installed version of the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CURR_VERS_COUNT IS 'The number of projects that have implemented the given resource that are the same as the current version';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.OLD_VERS_COUNT IS 'The number of projects that have implemented the given resource that are not the same as the current version';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.TOTAL_IMPL_PROJ IS 'The total number of projects that have implemented the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.ASSOC_PROJ_CD_LIST IS 'A comma-delimited list of projects and associated highest version number that have implemented the given resource.  If the current version implemented is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.ASSOC_PROJ_BR_LIST IS 'A web line-break-delimited (<BR>) list of projects and associated highest version number that have implemented the given resource.  If the current version implemented is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.ASSOC_PROJ_LINK_BR_LIST IS 'A web line-break-delimited (<BR>) list of projects and associated highest version number in a formatted hyperlink with a relative path to the given Resource Inventory App project that has implemented the given resource.  If the current version implemented is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.VC_PROJ_ID IS 'Unique numeric ID of the project in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_DESC IS 'Description of the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.SSH_URL IS 'SSH URL for the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.HTTP_URL IS 'HTTP URL for the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.README_URL IS 'Readme URL for the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.AVATAR_URL IS 'Avatar URL for the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_CREATE_DTM IS 'The date/time the project was created';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_UPDATE_DTM IS 'The date/time the project was last updated';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private)';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_NAME_SPACE IS 'project name including the namespace prefix';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.DATA_SOURCE_ID IS 'Primary key for the project''s Data Source';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.DATA_SOURCE_CODE IS 'Code for the given project''s Data Source';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.DATA_SOURCE_NAME IS 'Name of the given project''s Data Source';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.DATA_SOURCE_DESC IS 'Description for the given project''s Data Source';



COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.VC_OWNER_ID IS 'Unique numeric User ID of the project''s owner in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.OWNER_USER_ID IS 'The Project Owner''s User ID for the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.OWNER_USERNAME IS 'Login username for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.OWNER_USER_NAME IS 'Name of the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.OWNER_USER_EMAIL IS 'Email for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.OWNER_AVATAR_URL IS 'Avatar URL for the project owner''s user account in the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.OWNER_WEB_URL IS 'Web URL for the project owner''s user account in the version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.VC_CREATOR_ID IS 'Unique numeric User ID of the project''s creator in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CREATOR_USER_ID IS 'The Project Creator''s User ID for the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CREATOR_USERNAME IS 'Login username for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CREATOR_USER_NAME IS 'Name of the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CREATOR_USER_EMAIL IS 'Email for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CREATOR_AVATAR_URL IS 'Avatar URL for the project creator''s user account in the version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CREATOR_WEB_URL IS 'Web URL for the project creator''s user account in the version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.VC_WEB_URL IS 'The web URL of the project in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.VC_OPEN_ISSUES_COUNT IS 'The number of open issues for the project in the given version control system';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.VC_COMMIT_COUNT IS 'The total number of commits for the project in the given version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.VC_REPO_SIZE IS 'The total repository size in bytes for the project in the given version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.FORMAT_VC_REPO_SIZE_MB IS 'The total repository size in MB for the project in the given version control system formatted as a string with a leading zero for values < 1';


COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_CATEGORY IS 'The resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_TAG_CONV IS 'Tag Naming convention used to identify the given project resource''s version.  The suffix is required to be a series of period-delimited numbers (e.g. for a naming convention of db_module_packager_v the tag value of db_module_packager_v1.13.4 is valid)';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_COLOR_CODE IS 'The color code for the project resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_URL IS 'The URL for the project resource (this is blank when the repository URL is the same as the resource URL)';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_SCOPE_ID IS 'Foreign key reference to the resource scope';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_SCOPE_CODE IS 'Code for the given Resource Scope';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_SCOPE_NAME IS 'Name of the given Resource Scope';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_SCOPE_DESC IS 'Description for the given Resource Scope';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_TYPE_ID IS 'Foreign key reference to the resource type';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_TYPE_CODE IS 'Code for the given Resource Type';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_TYPE_NAME IS 'Name of the given Resource Type';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_TYPE_DESC IS 'Description for the given Resource Type';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_DESC IS 'The description for the project resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';


COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CREATE_DATE IS 'The date the project record was created in the database';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.CREATED_BY IS 'The Oracle username of the person that created the project record in the database';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.LAST_MOD_DATE IS 'The last date on which any of the data in the project record was changed';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to the project record';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_REFRESH_DATE IS 'The date of the last time the project information was refreshed in the database';

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('PIFSC Resource Inventory', '0.4', TO_DATE('', 'DD-MON-YY'), '');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
