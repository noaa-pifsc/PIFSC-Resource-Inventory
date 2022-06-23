--------------------------------------------------------
--------------------------------------------------------
--Database Name: PIFSC Resource Inventory
--Database Description: This project was developed to maintain an inventory of software and data resources to promote reuse of the tools, SOPs, etc. that can be utilized the improve, streamline, and support the data processes within PIFSC
--------------------------------------------------------
--------------------------------------------------------


--------------------------------------------------------
--PIFSC Resource Inventory - version 0.5 updates:
--------------------------------------------------------



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
LISTAGG((CASE WHEN PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME IS NOT NULL THEN '<a href="./view_project.php?PROJ_ID='||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_ID||'">'||(CASE WHEN TAG_MAX_VERS_YN = 'Y' THEN '(*CV) ' ELSE '(*UA) ' END)||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME||' (v'||PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_MAX_VERS_NUM||')</a>' ELSE NULL END), '<BR>') WITHIN GROUP (order by PRI_RES_PROJ_TAG_MAX_V.TAG_PROJ_NAME) ASSOC_PROJ_LINK_BR_LIST



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

--define the upgrade version in the database upgrade log table:
INSERT INTO DB_UPGRADE_LOGS (UPGRADE_APP_NAME, UPGRADE_VERSION, UPGRADE_DATE, UPGRADE_DESC) VALUES ('PIFSC Resource Inventory', '0.5', TO_DATE('23-JUN-22', 'DD-MON-YY'), 'Updated PRI_RES_PROJ_TAG_MAX_SUM_V view to update the internal link to use the tagged project IDs instead of the resource''s parent project.');

--commit the DB_UPGRADE_LOGS record insertion
COMMIT;
