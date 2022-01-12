--------------------------------------------------------
--------------------------------------------------------
--Database Name: PIFSC Resource Inventory
--Database Description: This project was developed to maintain an inventory of software and data resources to promote reuse of the tools, SOPs, etc. that can be utilized the improve, streamline, and support the data processes within PIFSC
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--PIFSC Resource Inventory - version 0.2 updates:
--------------------------------------------------------




CREATE TABLE PRI_RES_SCOPES
(
  RES_SCOPE_ID NUMBER NOT NULL
, RES_SCOPE_CODE VARCHAR2(50)
, RES_SCOPE_NAME VARCHAR2(200) NOT NULL
, RES_SCOPE_DESC VARCHAR2(500)
, CONSTRAINT PRI_RES_SCOPES_PK PRIMARY KEY
  (
    RES_SCOPE_ID
  )
  ENABLE
);

COMMENT ON COLUMN PRI_RES_SCOPES.RES_SCOPE_ID IS 'Primary key for the Resource Scope table';

COMMENT ON COLUMN PRI_RES_SCOPES.RES_SCOPE_CODE IS 'Code for the given Resource Scope';

COMMENT ON COLUMN PRI_RES_SCOPES.RES_SCOPE_NAME IS 'Name of the given Resource Scope';

COMMENT ON COLUMN PRI_RES_SCOPES.RES_SCOPE_DESC IS 'Description for the given Resource Scope';

COMMENT ON TABLE PRI_RES_SCOPES IS 'Reference Table for storing Resource Scope information';

ALTER TABLE PRI_RES_SCOPES ADD CONSTRAINT PRI_RES_SCOPES_U1 UNIQUE
(
  RES_SCOPE_CODE
)
ENABLE;

ALTER TABLE PRI_RES_SCOPES ADD CONSTRAINT PRI_RES_SCOPES_U2 UNIQUE
(
  RES_SCOPE_NAME
)
ENABLE;

ALTER TABLE PRI_RES_SCOPES ADD (CREATE_DATE DATE );
ALTER TABLE PRI_RES_SCOPES ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE PRI_RES_SCOPES ADD (LAST_MOD_DATE DATE );
ALTER TABLE PRI_RES_SCOPES ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN PRI_RES_SCOPES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN PRI_RES_SCOPES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN PRI_RES_SCOPES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN PRI_RES_SCOPES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';


CREATE SEQUENCE PRI_RES_SCOPES_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER PRI_RES_SCOPES_AUTO_BRI
before insert on PRI_RES_SCOPES
for each row
begin
  select PRI_RES_SCOPES_SEQ.nextval into :new.RES_SCOPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

	CREATE OR REPLACE TRIGGER PRI_RES_SCOPES_AUTO_BRU BEFORE
  UPDATE
    ON PRI_RES_SCOPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/


CREATE TABLE PRI_RES_TYPES
(
  RES_TYPE_ID NUMBER NOT NULL
, RES_TYPE_CODE VARCHAR2(50)
, RES_TYPE_NAME VARCHAR2(200) NOT NULL
, RES_TYPE_DESC VARCHAR2(500)
, CONSTRAINT PRI_RES_TYPES_PK PRIMARY KEY
  (
    RES_TYPE_ID
  )
  ENABLE
);

COMMENT ON COLUMN PRI_RES_TYPES.RES_TYPE_ID IS 'Primary key for the Resource Type table';

COMMENT ON COLUMN PRI_RES_TYPES.RES_TYPE_CODE IS 'Code for the given Resource Type';

COMMENT ON COLUMN PRI_RES_TYPES.RES_TYPE_NAME IS 'Name of the given Resource Type';

COMMENT ON COLUMN PRI_RES_TYPES.RES_TYPE_DESC IS 'Description for the given Resource Type';

COMMENT ON TABLE PRI_RES_TYPES IS 'Reference Table for storing Resource Type information';

ALTER TABLE PRI_RES_TYPES ADD CONSTRAINT PRI_RES_TYPES_U1 UNIQUE
(
  RES_TYPE_CODE
)
ENABLE;

ALTER TABLE PRI_RES_TYPES ADD CONSTRAINT PRI_RES_TYPES_U2 UNIQUE
(
  RES_TYPE_NAME
)
ENABLE;

ALTER TABLE PRI_RES_TYPES ADD (CREATE_DATE DATE );
ALTER TABLE PRI_RES_TYPES ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE PRI_RES_TYPES ADD (LAST_MOD_DATE DATE );
ALTER TABLE PRI_RES_TYPES ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN PRI_RES_TYPES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN PRI_RES_TYPES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN PRI_RES_TYPES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN PRI_RES_TYPES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

CREATE SEQUENCE PRI_RES_TYPES_SEQ INCREMENT BY 1 START WITH 1;

create or replace TRIGGER PRI_RES_TYPES_AUTO_BRI
before insert on PRI_RES_TYPES
for each row
begin
  select PRI_RES_TYPES_SEQ.nextval into :new.RES_TYPE_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

	CREATE OR REPLACE TRIGGER PRI_RES_TYPES_AUTO_BRU BEFORE
  UPDATE
    ON PRI_RES_TYPES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/

--project resource table (to define specific tools, SOPs, etc.):
CREATE TABLE PRI_PROJ_RES
(
	RES_ID NUMBER NOT NULL
, PROJ_ID NUMBER NOT NULL
, RES_CATEGORY VARCHAR2 (500)
, RES_SCOPE_ID NUMBER NOT NULL
, RES_TYPE_ID NUMBER NOT NULL
, RES_TAG_CONV VARCHAR2 (100) NOT NULL
, RES_NAME VARCHAR2 (500) NOT NULL
, RES_COLOR_CODE VARCHAR2 (7) NOT NULL
, RES_URL VARCHAR2 (500)
, CONSTRAINT PRI_PROJ_RES_PK PRIMARY KEY
	(
		RES_ID
	)
	ENABLE
);

COMMENT ON TABLE PRI_PROJ_RES IS 'Project Resources

This table defines the different types of specific resources (tools, SOPs, etc.) associated with a given project.  This information is used to parse tag names, define display colors, etc.';

COMMENT ON COLUMN PRI_PROJ_RES.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_PROJ_RES.PROJ_ID IS 'Foreign key reference to the project record';
COMMENT ON COLUMN PRI_PROJ_RES.RES_CATEGORY IS 'The resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications';
COMMENT ON COLUMN PRI_PROJ_RES.RES_SCOPE_ID IS 'Foreign key reference to the resource scope';
COMMENT ON COLUMN PRI_PROJ_RES.RES_TYPE_ID IS 'Foreign key reference to the resource type';
COMMENT ON COLUMN PRI_PROJ_RES.RES_TAG_CONV IS 'Tag Naming convention used to identify the given project resource''s version.  The suffix is required to be a series of period-delimited numbers (e.g. for a naming convention of db_module_packager_v the tag value of db_module_packager_v1.13.4 is valid)';
COMMENT ON COLUMN PRI_PROJ_RES.RES_NAME IS 'The name of the project resource';
COMMENT ON COLUMN PRI_PROJ_RES.RES_COLOR_CODE IS 'The color code for the project resource';
COMMENT ON COLUMN PRI_PROJ_RES.RES_URL IS 'The URL for the project resource (this is blank when the repository URL is the same as the resource URL)';

CREATE INDEX PRI_PROJ_RES_I1 ON PRI_PROJ_RES (PROJ_ID);

CREATE INDEX PRI_PROJ_RES_I2 ON PRI_PROJ_RES (RES_SCOPE_ID);

CREATE INDEX PRI_PROJ_RES_I3 ON PRI_PROJ_RES (RES_TYPE_ID);

ALTER TABLE PRI_PROJ_RES
ADD CONSTRAINT PRI_PROJ_RES_FK1 FOREIGN KEY
(
  PROJ_ID
)
REFERENCES PRI_PROJ
(
  PROJ_ID
)
ENABLE;

ALTER TABLE PRI_PROJ_RES
ADD CONSTRAINT PRI_PROJ_RES_FK2 FOREIGN KEY
(
  RES_SCOPE_ID
)
REFERENCES PRI_RES_SCOPES
(
  RES_SCOPE_ID
)
ENABLE;

ALTER TABLE PRI_PROJ_RES
ADD CONSTRAINT PRI_PROJ_RES_FK3 FOREIGN KEY
(
  RES_TYPE_ID
)
REFERENCES PRI_RES_TYPES
(
  RES_TYPE_ID
)
ENABLE;



ALTER TABLE PRI_PROJ_RES ADD (CREATE_DATE DATE );
ALTER TABLE PRI_PROJ_RES ADD (CREATED_BY VARCHAR2(30) );
ALTER TABLE PRI_PROJ_RES ADD (LAST_MOD_DATE DATE );
ALTER TABLE PRI_PROJ_RES ADD (LAST_MOD_BY VARCHAR2(30) );
COMMENT ON COLUMN PRI_PROJ_RES.CREATE_DATE IS 'The date on which this record was created in the database';
COMMENT ON COLUMN PRI_PROJ_RES.CREATED_BY IS 'The Oracle username of the person creating this record in the database';
COMMENT ON COLUMN PRI_PROJ_RES.LAST_MOD_DATE IS 'The last date on which any of the data in this record was changed';
COMMENT ON COLUMN PRI_PROJ_RES.LAST_MOD_BY IS 'The Oracle username of the person making the most recent change to this record';

ALTER TABLE PRI_PROJ_RES
ADD CONSTRAINT PRI_PROJ_RES_U1 UNIQUE
(
  PROJ_ID
, RES_NAME
)
ENABLE;


CREATE SEQUENCE PRI_PROJ_RES_SEQ INCREMENT BY 1 START WITH 1;




create or replace TRIGGER PRI_PROJ_RES_AUTO_BRI
before insert on PRI_PROJ_RES
for each row
begin
  select PRI_PROJ_RES_SEQ.nextval into :new.RES_ID from dual;
  :NEW.CREATE_DATE := SYSDATE;
  :NEW.CREATED_BY := nvl(v('APP_USER'),user);
end;
/

	CREATE OR REPLACE TRIGGER PRI_PROJ_RES_AUTO_BRU BEFORE
  UPDATE
    ON PRI_PROJ_RES FOR EACH ROW
    BEGIN
      :NEW.LAST_MOD_DATE := SYSDATE;
      :NEW.LAST_MOD_BY := nvl(v('APP_USER'),user);
END;
/



CREATE OR REPLACE VIEW
PRI_RES_V
AS
SELECT
PRI_PROJ_RES.RES_ID,
PRI_PROJ_RES.PROJ_ID,
PRI_PROJ_RES.RES_CATEGORY,
PRI_PROJ_RES.RES_TAG_CONV,
PRI_PROJ_RES.RES_NAME,
PRI_PROJ_RES.RES_COLOR_CODE,
PRI_PROJ_RES.RES_URL,
PRI_PROJ_RES.RES_SCOPE_ID,
PRI_RES_SCOPES.RES_SCOPE_CODE,
PRI_RES_SCOPES.RES_SCOPE_NAME,
PRI_RES_SCOPES.RES_SCOPE_DESC,
PRI_PROJ_RES.RES_TYPE_ID,
PRI_RES_TYPES.RES_TYPE_CODE,
PRI_RES_TYPES.RES_TYPE_NAME,
PRI_RES_TYPES.RES_TYPE_DESC
FROM
PRI_PROJ_RES
INNER JOIN PRI_RES_SCOPES ON PRI_PROJ_RES.RES_SCOPE_ID = PRI_RES_SCOPES.RES_SCOPE_ID
INNER JOIN PRI_RES_TYPES ON PRI_PROJ_RES.RES_TYPE_ID = PRI_RES_TYPES.RES_TYPE_ID
order by
PRI_RES_TYPES.RES_TYPE_NAME,
PRI_RES_SCOPES.RES_SCOPE_NAME,
PRI_PROJ_RES.RES_NAME
;

COMMENT ON TABLE PRI_RES_V IS 'Project Resources (View)

This view returns all project resources and associated reference table values';

COMMENT ON COLUMN PRI_RES_V.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_RES_V.PROJ_ID IS 'Foreign key reference to the project record';
COMMENT ON COLUMN PRI_RES_V.RES_CATEGORY IS 'The resource category (free form text) - examples values include Development Tool, Data Management Tool, Centralized Database Applications';
COMMENT ON COLUMN PRI_RES_V.RES_SCOPE_ID IS 'Foreign key reference to the resource scope';
COMMENT ON COLUMN PRI_RES_V.RES_TYPE_ID IS 'Foreign key reference to the resource type';
COMMENT ON COLUMN PRI_RES_V.RES_TAG_CONV IS 'Tag Naming convention used to identify the given project resource''s version.  The suffix is required to be a series of period-delimited numbers (e.g. for a naming convention of db_module_packager_v the tag value of db_module_packager_v1.13.4 is valid)';
COMMENT ON COLUMN PRI_RES_V.RES_NAME IS 'The name of the project resource';
COMMENT ON COLUMN PRI_RES_V.RES_COLOR_CODE IS 'The color code for the project resource';
COMMENT ON COLUMN PRI_RES_V.RES_URL IS 'The URL for the project resource (this is blank when the repository URL is the same as the resource URL)';
COMMENT ON COLUMN PRI_RES_V.RES_SCOPE_CODE IS 'Code for the given Resource Scope';
COMMENT ON COLUMN PRI_RES_V.RES_SCOPE_NAME IS 'Name of the given Resource Scope';
COMMENT ON COLUMN PRI_RES_V.RES_SCOPE_DESC IS 'Description for the given Resource Scope';
COMMENT ON COLUMN PRI_RES_V.RES_TYPE_CODE IS 'Code for the given Resource Type';
COMMENT ON COLUMN PRI_RES_V.RES_TYPE_NAME IS 'Name of the given Resource Type';
COMMENT ON COLUMN PRI_RES_V.RES_TYPE_DESC IS 'Description for the given Resource Type';




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
PRI_PROJ.PROJ_SOURCE,
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
PRI_RES_V.RES_TYPE_DESC
FROM PRI_PROJ
LEFT JOIN PRI_RES_V ON PRI_PROJ.PROJ_ID = PRI_RES_V.PROJ_ID
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
COMMENT ON COLUMN PRI_PROJ_V.PROJ_SOURCE IS 'the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)';
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



--PIFSC Resource Inventory (PRI) Package Specification:
CREATE OR REPLACE PACKAGE PRI_PKG
--this package provides functions and procedures for implementing PRI business rules

AS



	--this function determines the score of a given version number (X.X.X.X...) so it can be readily sorted to determine the maximum version number from project tags
	--all error conditions will raise an application exception and will be logged in the database
	FUNCTION CALC_VERS_NUM_SCORE_FN (P_VERS_STRING IN VARCHAR2) RETURN NUMBER;

END PRI_PKG;
/

--PIFSC Resource Inventory (PRI) Package Body:
CREATE OR REPLACE PACKAGE BODY PRI_PKG
--this package provides functions and procedures for implementing PRI business rules

AS

	--this function determines the score of a given version number (X.X.X.X...) so it can be readily sorted to determine the maximum version number from project tags
	--all error conditions will raise an application exception and will be logged in the database
	FUNCTION CALC_VERS_NUM_SCORE_FN (P_VERS_STRING IN VARCHAR2) RETURN NUMBER IS

		--number variable used for calculating the version number score
		V_RET_SCORE NUMBER := 0;

--		V_SP_RET_CODE PLS_INTEGER;

		V_LOOP_COUNTER PLS_INTEGER := 0;

		--variable to store the constructed log source string for the current function
--		V_TEMP_LOG_SOURCE DB_LOG_ENTRIES.LOG_SOURCE%TYPE;

		--variable to store the exception message:
--		V_EXC_MSG VARCHAR2(2000);

	BEGIN

		--construct the DB_LOG_ENTRIES.LOG_SOURCE value for all logging messages in this function based on the function name and parameters:
--		V_TEMP_LOG_SOURCE := 'PRI_PKG.CALC_VERS_NUM_SCORE_FN ('||P_VERS_STRING||')';

--		DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'running PRI_PKG.CALC_VERS_NUM_SCORE_FN()',	V_SP_RET_CODE);


		--parse the version number string by the period characters
		FOR REC IN
			(select regexp_substr(P_VERS_STRING,
                    '[^.]+', 1, level) VERSION_NUMBER from dual connect by regexp_substr(P_VERS_STRING,
                        '[^.]+',1,level) is not null)
		LOOP

--			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The current number is: '||REC.VERSION_NUMBER,	V_SP_RET_CODE);

			V_RET_SCORE := V_RET_SCORE + (TO_NUMBER(REC.VERSION_NUMBER) * POWER(1000, -V_LOOP_COUNTER));

--			DB_LOG_PKG.ADD_LOG_ENTRY('DEBUG', V_TEMP_LOG_SOURCE, 'The current combined version number score is: '||V_RET_SCORE,	V_SP_RET_CODE);

			--increment the loop counter
			V_LOOP_COUNTER := V_LOOP_COUNTER + 1;

		END LOOP;

		RETURN V_RET_SCORE;

	END CALC_VERS_NUM_SCORE_FN;





END PRI_PKG;
/




--query to relate all resources and project tags based on the tag naming conventions
CREATE OR REPLACE VIEW
PRI_RES_TAG_VERS_V
AS

select
PRI_PROJ_RES.RES_ID,
PRI_PROJ_RES.PROJ_ID RES_PROJ_ID,
PRI_PROJ_TAGS.PROJ_ID TAG_PROJ_ID,
PRI_PROJ_TAGS.TAG_ID,
REGEXP_SUBSTR(PRI_PROJ_TAGS.TAG_NAME, '^'||PRI_PROJ_RES.RES_TAG_CONV||'([0-9]+(\.[0-9]+)*)', 1, 1, 'i', 1) VERS_NUM,
PRI_PKG.CALC_VERS_NUM_SCORE_FN(REGEXP_SUBSTR(PRI_PROJ_TAGS.TAG_NAME, '^'||PRI_PROJ_RES.RES_TAG_CONV||'([0-9]+(\.[0-9]+)*)', 1, 1, 'i', 1)) VERS_NUM_SCORE
FROM
PRI_PROJ_RES
INNER JOIN
PRI_PROJ_TAGS
--ON PRI_PROJ_RES.PROJ_ID = PRI_PROJ_TAGS.PROJ_ID
ON REGEXP_LIKE (PRI_PROJ_TAGS.TAG_NAME, '^'||PRI_PROJ_RES.RES_TAG_CONV||'([0-9]+(\.[0-9]+)*)', 'i');

COMMENT ON TABLE PRI_RES_TAG_VERS_V IS 'Project Resource Tag Versions (View)

This view returns all defined project resources and associated tag names that match the corresponding resource tag naming convention based on a regular expression.  The view also provides the parsed version number based on the naming convention and a score for the parsed version number that is used to determine the highest version number';

COMMENT ON COLUMN PRI_RES_TAG_VERS_V.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_RES_TAG_VERS_V.RES_PROJ_ID IS 'The project that is directly associated with the given defined resource (foreign key relationship)';

COMMENT ON COLUMN PRI_RES_TAG_VERS_V.TAG_PROJ_ID IS 'The project that is associated with the given defined resource based on the tags associated with the project and the tag naming convention defined for the resource';

COMMENT ON COLUMN PRI_RES_TAG_VERS_V.TAG_ID IS 'Primary key for the PRI_PROJ_TAGS table';

COMMENT ON COLUMN PRI_RES_TAG_VERS_V.VERS_NUM IS 'The parsed version number of the commit for the defined tag naming conventions for the corresponding resource';

COMMENT ON COLUMN PRI_RES_TAG_VERS_V.VERS_NUM_SCORE IS 'The version number score for the parsed version number of the commit for the defined tag naming conventions for the corresponding resource.  This number is used to determine the maximum (current) version of the resource';


--PRI_RES_PROJ_VERS_V

CREATE OR REPLACE VIEW

PRI_RES_TAG_MAX_VERS_V
AS

select
PRI_RES_TAG_VERS_V.RES_ID,
PRI_RES_TAG_VERS_V.RES_PROJ_ID,
PRI_RES_TAG_VERS_V.TAG_PROJ_ID,
MAX (PRI_RES_TAG_VERS_V.TAG_ID) KEEP (DENSE_RANK FIRST ORDER BY PRI_RES_TAG_VERS_V.VERS_NUM_SCORE DESC) MAX_TAG_ID,
MAX (PRI_RES_TAG_VERS_V.VERS_NUM) KEEP (DENSE_RANK FIRST ORDER BY PRI_RES_TAG_VERS_V.VERS_NUM_SCORE DESC) MAX_VERS_NUM
FROM

PRI_RES_TAG_VERS_V

GROUP BY PRI_RES_TAG_VERS_V.RES_ID,
PRI_RES_TAG_VERS_V.RES_PROJ_ID,
PRI_RES_TAG_VERS_V.TAG_PROJ_ID
;

COMMENT ON TABLE PRI_RES_TAG_MAX_VERS_V IS 'Project Resource Tag Maximum Versions (View)

This view returns the highest version number of each defined project resource that is associated with each project based on the tag IDs associated with the project resources.  This view can be used to identify all instances of resources implemented for a given project (identified TAG_PROJ_ID) and it can be used to identify which project resources are installed in a given project (identified by RES_PROJ_ID)';

COMMENT ON COLUMN PRI_RES_TAG_MAX_VERS_V.RES_ID IS 'Primary key for the PRI_PROJ_RES table';
COMMENT ON COLUMN PRI_RES_TAG_MAX_VERS_V.RES_PROJ_ID IS 'The project that is directly associated with the given defined resource (foreign key relationship)';

COMMENT ON COLUMN PRI_RES_TAG_MAX_VERS_V.TAG_PROJ_ID IS 'The project that is associated with the given defined resource based on the tags associated with the project and the tag naming convention defined for the resource';

COMMENT ON COLUMN PRI_RES_TAG_MAX_VERS_V.MAX_TAG_ID IS 'The TAG_ID value associated with the highest version number of the resource associated with the given project (identified by TAG_PROJ_ID)';

COMMENT ON COLUMN PRI_RES_TAG_MAX_VERS_V.MAX_VERS_NUM IS 'The parsed version number for the maximum installed version of the resource implemented by the given project (identified by TAG_PROJ_ID)';




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
PRI_PROJ_V.PROJ_SOURCE,
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
TAG_PROJ.PROJ_SOURCE TAG_PROJ_SOURCE

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
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.PROJ_SOURCE IS 'the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)';
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
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_AVATAR_URL IS 'Avatar URL for the project project associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_CREATE_DTM IS 'The date/time the project associated with the given resource was created';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_UPDATE_DTM IS 'The date/time the project associated with the given resource was last updated';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_VISIBILITY IS 'The visibility for the project (public, internal, private) associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME_SPACE IS 'project name including the namespace prefix associated with the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_SOURCE IS 'the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry) associated with the given resource';



CREATE OR REPLACE VIEW
PRI_RES_PROJ_TAG_MAX_SUM_V
AS
SELECT
PRI_RES_PROJ_TAG_MAX_V.PROJ_ID,
PRI_RES_PROJ_TAG_MAX_V.PROJ_NAME,
PRI_RES_PROJ_TAG_MAX_V.RES_NAME,
PRI_RES_PROJ_TAG_MAX_V.RES_MAX_VERS_NUM,
SUM(CASE WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'Y' THEN 1 WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'N' THEN 0 ELSE NULL END) CURR_VERS_COUNT,
SUM(CASE WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'N' THEN 1 WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'Y' THEN 0 ELSE NULL END) OLD_VERS_COUNT,
SUM (CASE WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '*CV ' ELSE '*UA ' END)|| PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM IS NOT NULL THEN 1 ELSE NULL END) TOTAL_IMPL_PROJ,
LISTAGG((CASE WHEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS NOT NULL THEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME||' (v'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), ', ') WITHIN GROUP (order by PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME) ASSOC_PROJ_CD_LIST

FROM PRI_RES_PROJ_TAG_MAX_V
GROUP BY
PRI_RES_PROJ_TAG_MAX_V.PROJ_ID,
PRI_RES_PROJ_TAG_MAX_V.PROJ_NAME,
PRI_RES_PROJ_TAG_MAX_V.RES_NAME,
PRI_RES_PROJ_TAG_MAX_V.RES_MAX_VERS_NUM
;
COMMENT ON TABLE PRI_RES_PROJ_TAG_MAX_SUM_V IS 'Resource and Installed Project Maximum Versions Summary (View)

This view returns the projects and associated resource (including highest version) and a summary of all associated projects that tag the resource (as implemented).';

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.RES_NAME IS 'The name of the project resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.RES_MAX_VERS_NUM IS 'The parsed version number for the maximum installed version of the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.CURR_VERS_COUNT IS 'The number of projects that have implemented the given resource that are the same as the current version';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.OLD_VERS_COUNT IS 'The number of projects that have implemented the given resource that are not the same as the current version';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.TOTAL_IMPL_PROJ IS 'The total number of projects that have implemented the given resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_V.ASSOC_PROJ_CD_LIST IS 'A comma-delimited list of projects and associated highest version number that have implemented the given resource.  If the current version implemented is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';






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
PRI_PROJ.PROJ_SOURCE,
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
PRI_PROJ_V.PROJ_SOURCE RES_PROJ_SOURCE,
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
PRI_PROJ_V.RES_TYPE_DESC

FROM

--get the projects associated with each of the resources
PRI_PROJ



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
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.PROJ_SOURCE IS 'the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)';
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
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_PROJ_SOURCE IS 'the source of the resource project record (e.g. PIFSC GitLab, GitHub, manual entry)';
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

--summary view for all projects and associated (implemented) resources
CREATE OR REPLACE VIEW
PRI_PROJ_RES_TAG_MAX_SUM_V
AS
SELECT
PRI_PROJ_RES_TAG_MAX_V.PROJ_ID,
PRI_PROJ_RES_TAG_MAX_V.PROJ_NAME,
ASSOC_RES.RES_NAME_CD_LIST,
ASSOC_RES.NUM_RES,

SUM(CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'Y' THEN 1 WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'N' THEN 0 ELSE NULL END) CURR_VERS_COUNT,
SUM(CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'N' THEN 1 WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND TAG_MAX_VERS_YN = 'Y' THEN 0 ELSE NULL END) OLD_VERS_COUNT,
SUM (CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL AND PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM IS NOT NULL THEN 1 ELSE NULL END) TOTAL_IMPL_RES,
LISTAGG((CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL THEN (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '*CV ' ELSE '*UA ' END)|| PRI_PROJ_RES_TAG_MAX_V.RES_NAME||' (v'||PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), ', ') WITHIN GROUP (order by PRI_PROJ_RES_TAG_MAX_V.RES_NAME) IMPL_RES_CD_LIST

FROM PRI_PROJ_RES_TAG_MAX_V
LEFT JOIN
(
SELECT
PRI_PROJ_RES.PROJ_ID,
LISTAGG (RES_NAME|| ' (v'||MAX_VERS_NUM||')', ', ') WITHIN GROUP (order by RES_NAME) RES_NAME_CD_LIST,
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
ASSOC_RES.NUM_RES;


COMMENT ON TABLE PRI_PROJ_RES_TAG_MAX_SUM_V IS 'Project Resource Implementations Maximum Versions Summary (View)

This view returns all projects and summary information of all implemented resources including highest version implemented';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.PROJ_ID IS 'Primary key for the PRI_PROJ table';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.PROJ_NAME IS 'Name of the project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.CURR_VERS_COUNT IS 'The number of implemented resources that have been implemented by the project that are the same as the current version of the resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.OLD_VERS_COUNT IS 'The number of implemented resources that have been implemented by the project that are not the same as the current version of the resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.TOTAL_IMPL_RES IS 'The total number of project resources that have been implemented in the given project';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.IMPL_RES_CD_LIST IS 'A comma-delimited list of project resources and associated highest version number that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.RES_NAME_CD_LIST IS 'A comma-delimited list of project resources and associated highest version number that are associated with the project';

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_V.NUM_RES IS 'The number of associated resources with the project';



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('PIFSC Resource Inventory', '0.2', TO_DATE('11-JAN-22', 'DD-MON-YY'), 'Defined new reference tables (PRI_RES_SCOPES, PRI_RES_TYPES) for resources and a new resources table (PRI_PROJ_RES) as well as all supporting objects.  Defined new view PRI_RES_V to relate the PRI_PROJ_RES and reference tables.  PRI_PROJ_V was created to relate the project and resource information.  A new PL/SQL package PRI_PKG was created to define a new function CALC_VERS_NUM_SCORE_FN to take an arbitrary period-delimited string of integers and calculate a score to determine the largest version number which is the current version for a given resource or implemented resource.  A new PRI_RES_TAG_VERS_V view was created to parse the version number based on associated tag names and the defined resource naming convention.  A new PRI_RES_TAG_MAX_VERS_V was created to determine the highest (current) version of a given project based on the define resource naming convention.  PRI_RES_PROJ_TAG_MAX_V returns all project resources (including highest version) and all associated projects that tag the resource (as implemented) including the highest version number for the associated tagged project.  PRI_RES_PROJ_TAG_MAX_SUM_V view returns the projects and associated resource (including highest version) and a summary of all associated projects that tag the resource (as implemented).  PRI_PROJ_RES_TAG_MAX_V view returns all projects and associated implemented resources including highest version implemented and highest resource version as well as the resource''s project information.  PRI_PROJ_RES_TAG_MAX_SUM_V view returns all projects and summary information of all implemented resources including highest version implemented');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
