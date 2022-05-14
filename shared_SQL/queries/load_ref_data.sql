--resource types:
INSERT INTO PRI_RES_TYPES (RES_TYPE_CODE, RES_TYPE_NAME, RES_TYPE_DESC) VALUES ('Tool', 'Software Tool', 'The given resource is a software tool');
INSERT INTO PRI_RES_TYPES (RES_TYPE_CODE, RES_TYPE_NAME, RES_TYPE_DESC) VALUES ('SOP', 'Standard Operating Procedure', 'The given resource is a standard operating procedure');
INSERT INTO PRI_RES_TYPES (RES_TYPE_CODE, RES_TYPE_NAME, RES_TYPE_DESC) VALUES ('DGM', 'Diagram', 'The given resource is a diagram or collection of diagrams or other visual representations');
INSERT INTO PRI_RES_TYPES (RES_TYPE_CODE, RES_TYPE_NAME, RES_TYPE_DESC) VALUES ('TM', 'Training Materials', 'The given resource is training materials (how to, getting started, class materials, step-by-step instructions, etc.)');
INSERT INTO PRI_RES_TYPES (RES_TYPE_CODE, RES_TYPE_NAME, RES_TYPE_DESC) VALUES ('Temp', 'Template', 'Templates to streamline processes');
INSERT INTO PRI_RES_TYPES (RES_TYPE_CODE, RES_TYPE_NAME, RES_TYPE_DESC) VALUES ('Doc', 'Documentation', 'Documentation resources for guidance');




--resource scopes:
INSERT INTO PRI_RES_SCOPES (RES_SCOPE_CODE, RES_SCOPE_NAME, RES_SCOPE_DESC) VALUES ('SW', 'Software Development', 'The given resource is a Software Development resource intended for use by software developers');
INSERT INTO PRI_RES_SCOPES (RES_SCOPE_CODE, RES_SCOPE_NAME, RES_SCOPE_DESC) VALUES ('DS', 'Data Stewardship', 'The given resource is a data stewardship resource intended for use by data stewards');
INSERT INTO PRI_RES_SCOPES (RES_SCOPE_CODE, RES_SCOPE_NAME, RES_SCOPE_DESC) VALUES ('DG', 'Data Governance', 'The given resource is a data governance resource intended to support the Data Governance Program');
