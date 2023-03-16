# PIFSC Resource Inventory Git Info Module - Technical Documentation

## Overview:
The PIFSC Resource Inventory (PRI) Git Info Module (GIM) was developed to retrieve information from GitLab and GitHub version control systems and refresh a local database with Git project information.  This is a repeatable process that is intended to be automatically executed using a cron job.  

## Resources:
-   Version Control Information:
    -   URL:git@picgitlab.nmfs.local:centralized-data-tools/pifsc-resource-inventory.git in the [GIM](../) folder
    -   Application: 0.5 (Git tag: pifsc_resource_inventory_git_info_app_v0.5)
-   [PRI Database Documentation](../../docs/PIFSC%20Resource%20Inventory%20Database%20Documentation.md)
-   [Business Rule Documentation](../../docs/PIFSC%20Resource%20Inventory%20-%20Business%20Rule%20Documentation.md)
    -   [Business Rule List](../../docs/PRI%20Business%20Rule%20List.xlsx)
-   [Add or Remove Project SOP](../../docs/PIFSC%20Resource%20Inventory%20-%20Add%20or%20Remove%20Project%20SOP.md)
-   [Docker Project Technical Documentation](PIFSC%20Resource%20Inventory%20Docker%20App%20-%20Technical%20Documentation.md)
    -   [Docker Project User Documentation](PIFSC%20Resource%20Inventory%20Docker%20App%20-%20User%20Documentation.md)

## Requirements:
-   PHP 8.x
    -   Required PHP Libraries:
        -   OpenSSL (required for retrieving the GitLab/GitHub project information via SSL protocol)
        -   OCI8 (required for interaction with the Oracle database)
        -   Curl (required for REST API requests to GitLab/GitHub servers)
-   Oracle 12c or higher
-   PIFSC PHP Shared Library repository
    -   Version Control Information:
        -   URL: git@picgitlab.nmfs.local:centralized-data-tools/php-shared-library.git
        -   App: 1.11 (Git tag: php_shared_libary_v1.11)

## Data Flow:
-   [Data Flow Diagram (DFD)](../../docs/DFD/PRI_DFD.drawio.png)
-   [DFD Documentation](../../docs/DFD/PIFSC%20Resource%20Inventory%20Data%20Flow%20Diagram%20Documentation.md)

## Script setup:
-   [Docker Project Technical Documentation](PIFSC%20Resource%20Inventory%20Docker%20App%20-%20Technical%20Documentation.md)

## Business Rules:
-   The business rules for the GIM are defined in the [Business Rule Documentation](../../docs/PIFSC%20Resource%20Inventory%20-%20Business%20Rule%20Documentation.md) and each specific business rule listed in the [Business Rule List](../../docs/PRI%20Business%20Rule%20List.xlsx) with a Scope of "GIM" apply to this module and each rule with a Scope of "PRI Database" apply to the underlying database

## Features:
-   SQL Transactions are implemented when importing the project, tag, etc. information from the PIFSC GitLab server.  If there are errors encountered during the processing of a given project the transaction is rolled back.  The script logs will need to be consulted to determine the conditions that led up to the given project SQL processing error.  
-   Script Logs
    -   The database script log can be accessed via the DB_LOG_ENTRIES_V view for entries with LOG_SOURCE = 'retrieve_gitlab_info.php'
    -   The file-based script log can be accessed in the working copy of the PRI repository in the [logs](../application_code/logs) folder (retrieve_gitlab_info_[YYYYMMDD]_[HH24_MI].log based on the date/time the script was executed)
-   Custom Configuration Files
    -   Project resources can be defined using the [Project Resource Definition SOP](./Project%20Resource%20Definition%20SOP.md)

## Application Security:
-   [Principle of least privilege](https://docs.google.com/document/d/15qW2pDHM8bebmNJ76AfC-SgICKQPGmKSiUkXbrZ7OVQ/edit?usp=sharing): All of the data tables and support objects are defined in the PRI data schema (PRI), the GIM's parsing schema (shadow schema) which is used to actually interact with the underlying database is PRI_GIM_APP. PRI_GIM_APP has very limited permissions on the PRI schema based on the required functionality of the application (see [PRI_GIM_APP_permissions.xlsx](./PRI_GIM_APP_permissions.xlsx)) to implement the principle of least privilege. The PRI_GIM_APP schema has not been granted any roles in the database instance.
