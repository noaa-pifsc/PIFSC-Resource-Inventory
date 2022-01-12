--resource types:
INSERT INTO PRI_RES_TYPES (RES_TYPE_CODE, RES_TYPE_NAME, RES_TYPE_DESC) VALUES ('Tool', 'Software Tool', 'The given resource is a software tool');
INSERT INTO PRI_RES_TYPES (RES_TYPE_CODE, RES_TYPE_NAME, RES_TYPE_DESC) VALUES ('SOP', 'Standard Operating Procedure', 'The given resource is a standard operating procedure');



--resource scopes:
INSERT INTO PRI_RES_SCOPES (RES_SCOPE_CODE, RES_SCOPE_NAME, RES_SCOPE_DESC) VALUES ('SW Dev', 'Software Development', 'The given resource is a Software Development resource intended for use by software developers');
INSERT INTO PRI_RES_SCOPES (RES_SCOPE_CODE, RES_SCOPE_NAME, RES_SCOPE_DESC) VALUES ('DM', 'Data Management', 'The given resource is a Data Management resource intended for use by data managers');
