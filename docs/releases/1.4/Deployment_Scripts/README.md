# Version 1.4 Deployment Scripts

## Overview
This document provides information about the various files developed to safely deploy version 1.4 of the PIFSC Resource Inventory (PRI) Resource Inventory App (RIA) and the Git Info Module (GIM).  Version 1.0 of the database is also deployed to a blank schema.  The rollback script is included in this directory in the event that the upgrade fails and the database and application versions must be rolled back to its previous state.

## Resources
-   [automated deployments](./automated_deployments)
    -   These scripts were developed to automate and log the process of deploying/rolling back the database and application to support the system upgrade
    -   Note: All scripts should be run from the SQL directory in the repository root directory using SQL Plus utilizing the relative paths of the scripts in this directory
    -   Script Inventory:
        -   deploy_[INSTANCE]_v1.0.sql (e.g. [deploy_dev_v1.0.sql](./automated_deployments/deploy_dev_v1.0.sql)) - deploys version 1.0 of the database to a blank schema on the [INSTANCE] database
        -   deploy_[INSTANCE]_rollback_to_0.0.sql (e.g. [deploy_dev_rollback_to_0.0.sql](./automated_deployments/deploy_dev_rollback_to_0.0.sql)) - perform a rollback of the database upgrade from version 1.0 to 0.0 on the [INSTANCE] database
        -   deploy_RIA_[INSTANCE]_v1.4.sql (e.g. [deploy_RIA_dev_v1.4.sql](./automated_deployments/deploy_RIA_dev_v1.4.sql)) - deploys version 1.4 of the RIA (pre-upgrade production version) to the [INSTANCE] database
        -   deploy_RIA_[INSTANCE]_rollback_to_0.0.sql (e.g. [deploy_RIA_dev_rollback_to_0.0.sql](./automated_deployments/deploy_RIA_dev_rollback_to_0.0.sql)) - performs a rollback of the RIA application on the [INSTANCE] database
        -   deploy_GIM_[INSTANCE]_v1.4.sql (e.g. [deploy_GIM_dev_v1.4.sql](./automated_deployments/deploy_GIM_dev_v1.4.sql)) - deploys version 1.4 of the GIM (pre-upgrade production version) to the [INSTANCE] database
        -   deploy_GIM_[INSTANCE]_rollback_to_0.0.sql (e.g. [deploy_GIM_dev_rollback_to_0.0.sql](./automated_deployments/deploy_GIM_dev_rollback_to_0.0.sql)) - performs a rollback of the GIM application on the [INSTANCE] database
-   [calling_scripts](./calling_scripts)
    -   These scripts were developed to make it easier to execute the automated deployment scripts from a given working copy of the repository.  
    -   Replace the [working copy root] placeholders with the actual path to the root directory of the working copy of this repository before executing the statements.  When prompted provide the database credentials in SQL*Plus format (e.g. SCHEMA/PASSWORD@HOSTNAME/SID)
    -   Script Inventory:
        -   [INSTANCE]_deployment_script_upgrade_v0.0_to_v1.4.sql (e.g. [dev_deployment_script_upgrade_v0.0_to_v1.4.sql](./calling_scripts/dev_deployment_script_upgrade_v0.0_to_v1.4.sql)) - deploys version 1.4 of the database to a blank schema and deploys version 1.4 of the RIA and GIM applications to the [INSTANCE] schema
        -   [INSTANCE]_deployment_script_rollback_v1.4_to_v0.0.sql (e.g. [dev_deployment_script_rollback_v1.4_to_v0.0.sql](./calling_scripts/dev_deployment_script_rollback_v1.4_to_v0.0.sql)) - perform a rollback of the database upgrade from version 1.4 to 0.0 (pre-upgrade production version) and remove the RIA and GIM applications (pre-upgrade production version) from the [INSTANCE] server
-   [rollback](./rollback)
    -   These scripts were developed to rollback the database upgrade from version 1.0 to 0.0 to revert the database to its previous state before an upgrade if the application does not work or there is another issue.
    -   Script Inventory:
        -   [db_downgrade_1.0_to_0.0.sql](./rollback/db_downgrade_1.0_to_0.0.sql) - contains the DDL to revert the database changes due to the upgrade from version 1.0 to 0.0.
        -   [drop_PRI_GIM_APP_synonyms.sql](./rollback/drop_PRI_GIM_APP_synonyms.sql) - contains the DDL to remove the GIM Application schema's synonyms.
        -   [drop_PRI_RIA_APP_synonyms.sql](./rollback/drop_PRI_RIA_APP_synonyms.sql) - contains the DDL to remove the RIA Application schema's synonyms.
-   [db](./db)
    -   These scripts contain the database scripts to support the deployment of version 1.0 of the database
    -   Script Inventory:
        -   [load_ref_data.sql](./db/load_ref_data.sql) - loads the reference data for version 1.0 of the database
        -   [create_PRI_GIM_APP_synonyms.sql](./db/create_PRI_GIM_APP_synonyms.sql) - defines the synoyms for version 1.4 of the GIM application
        -   [grant_PRI_GIM_APP_privs.sql](./db/grant_PRI_GIM_APP_privs.sql) - grants permissions on objects in the data schema to the GIM application schema
        -   [create_PRI_RIA_APP_synonyms.sql](./db/create_PRI_RIA_APP_synonyms.sql) - defines the synoyms for version 1.4 of the RIA application
        -   [grant_PRI_RIA_APP_privs.sql](./db/grant_PRI_RIA_APP_privs.sql) - grants permissions on objects in the data schema to the RIA application schema