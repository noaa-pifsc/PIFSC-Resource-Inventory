--------------------------------------------------------
--------------------------------------------------------
--Database Name: PIFSC Resource Inventory
--Database Description: This project was developed to maintain an inventory of software and data resources to promote reuse of the tools, SOPs, etc. that can be utilized the improve, streamline, and support the data processes within PIFSC
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--PIFSC Resource Inventory - version 0.3 updates:
--------------------------------------------------------


ALTER TABLE PRI_PROJ_RES
ADD (RES_DESC VARCHAR2(2000) );

COMMENT ON COLUMN PRI_PROJ_RES.RES_DESC IS 'The description for the project resource';

ALTER TABLE PRI_PROJ_RES
MODIFY (RES_URL VARCHAR2(1000 BYTE) );


ALTER TABLE PRI_PROJ_RES
ADD (RES_DEMO_URL VARCHAR2(2000) );

COMMENT ON COLUMN PRI_PROJ_RES.RES_DEMO_URL IS 'The live demonstration URL for the project resource';


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
PRI_RES_TYPES.RES_TYPE_DESC,
PRI_PROJ_RES.RES_DESC,
PRI_PROJ_RES.RES_DEMO_URL
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

COMMENT ON COLUMN PRI_RES_V.RES_DESC IS 'The description for the project resource';

COMMENT ON COLUMN PRI_RES_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';

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
PRI_RES_V.RES_TYPE_DESC,
PRI_RES_V.RES_DESC,
PRI_RES_V.RES_DEMO_URL
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

COMMENT ON COLUMN PRI_PROJ_V.RES_DESC IS 'The description for the project resource';

COMMENT ON COLUMN PRI_PROJ_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';



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
PRI_PROJ_V.RES_DESC,
PRI_PROJ_V.RES_DEMO_URL,
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

COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_DESC IS 'The description for the project resource';
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';

ALTER VIEW PRI_RES_PROJ_TAG_MAX_SUM_V COMPILE;




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
PRI_PROJ_V.RES_TYPE_DESC,
PRI_PROJ_V.RES_DESC,
PRI_PROJ_V.RES_DEMO_URL

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

COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_DESC IS 'The description for the project resource';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';



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




LISTAGG((CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL THEN (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '*CV ' ELSE '*UA ' END)|| PRI_PROJ_RES_TAG_MAX_V.RES_NAME||' (v'||PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), ', ') WITHIN GROUP (order by PRI_PROJ_RES_TAG_MAX_V.RES_NAME) IMPL_RES_CD_LIST,
LISTAGG((CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL THEN (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '*CV ' ELSE '*UA ' END)|| PRI_PROJ_RES_TAG_MAX_V.RES_NAME||' (v'||PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_PROJ_RES_TAG_MAX_V.RES_NAME) IMPL_RES_BR_LIST,
LISTAGG((CASE WHEN PRI_PROJ_RES_TAG_MAX_V.RES_NAME IS NOT NULL THEN '<a href="./resource.php?RES_ID='||PRI_PROJ_RES_TAG_MAX_V.RES_ID||'">'||(CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '*CV ' ELSE '*UA ' END)|| PRI_PROJ_RES_TAG_MAX_V.RES_NAME||' (v'||PRI_PROJ_RES_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')</a>' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_PROJ_RES_TAG_MAX_V.RES_NAME) IMPL_RES_LINK_BR_LIST

FROM PRI_PROJ_RES_TAG_MAX_V
LEFT JOIN
(
SELECT
PRI_PROJ_RES.PROJ_ID,
LISTAGG (RES_NAME|| ' (v'||MAX_VERS_NUM||')', ', ') WITHIN GROUP (order by RES_NAME) RES_NAME_CD_LIST,
LISTAGG (RES_NAME|| ' (v'||MAX_VERS_NUM||')', '<BR>') WITHIN GROUP (order by RES_NAME) RES_NAME_BR_LIST,
LISTAGG ('<a href="./resource.php?RES_ID='||PRI_PROJ_RES.RES_ID||'">'||RES_NAME|| ' (v'||MAX_VERS_NUM||')</a>', '<BR>') WITHIN GROUP (order by RES_NAME) RES_NAME_LINK_BR_LIST,
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
PRI_PROJ.PROJ_SOURCE

FROM
PRI_PROJ_RES_TAG_MAX_SUM_V
INNER JOIN
PRI_PROJ ON PRI_PROJ_RES_TAG_MAX_SUM_V.PROJ_ID = PRI_PROJ.PROJ_ID;


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
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.PROJ_SOURCE IS 'the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)';


COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.IMPL_RES_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';
COMMENT ON COLUMN PRI_PROJ_RES_TAG_MAX_SUM_ALL_V.IMPL_RES_LINK_BR_LIST IS 'A web line-break-delimited (<BR>) list of project resources and associated highest version number in a formatted hyperlink with a relative path to the given Resource Inventory App resource that have been implemented by the project.  If the current version implemented in the project is the same as the current version of the resource the project name is preceded by a "*CV" prefix to indicate it is the current version and if not the "*UA" prefix is used to indicate there is an update available';







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
PRI_PROJ_V.RES_DEMO_URL,
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


COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_V.RES_DEMO_URL IS 'The live demonstration URL for the project resource';


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
SUM (CASE WHEN PRI_RES_PROJ_TAG_MAX_V.RES_NAME IS NOT NULL AND (CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '*CV ' ELSE '*UA ' END)|| PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM IS NOT NULL THEN 1 ELSE NULL END) TOTAL_IMPL_PROJ,
LISTAGG((CASE WHEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS NOT NULL THEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME||' (v'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), ', ') WITHIN GROUP (order by PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME) ASSOC_PROJ_CD_LIST,
LISTAGG((CASE WHEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS NOT NULL THEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME||' (v'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME) ASSOC_PROJ_BR_LIST,
LISTAGG((CASE WHEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS NOT NULL THEN '<a href="./project.php?PROJ_ID='||PRI_RES_PROJ_TAG_MAX_V.PROJ_ID||'">'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME||' (v'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')</a>' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME) ASSOC_PROJ_LINK_BR_LIST



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
PRI_PROJ_V.PROJ_SOURCE,
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
PRI_PROJ_V.RES_DEMO_URL


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
COMMENT ON COLUMN PRI_RES_PROJ_TAG_MAX_SUM_ALL_V.PROJ_SOURCE IS 'the source of the project record (e.g. PIFSC GitLab, GitHub, manual entry)';
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



--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('PIFSC Resource Inventory', '0.3', TO_DATE('11-MAY-22', 'DD-MON-YY'), '');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
