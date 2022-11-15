# PIFSC Resource Inventory Git Info Module - Technical Documentation

## Overview:
The PIFSC Resource Inventory (PRI) Git Info Module (GIM) was developed to retrieve information from GitLab and GitHub version control systems and refresh a local database with Git project information.  This is a repeatable process that is intended to be executed using a scheduled task/cron job.  

## Resources:
-   Version Control Information:
    -   URL:git@picgitlab.nmfs.local:centralized-data-tools/pifsc-resource-inventory.git in the [GIM](../) folder
    -   Application: 0.5 (Git tag: pifsc_resource_inventory_git_info_app_v0.5)
-   [PRI Database Documentation](../../docs/PIFSC%20Resource%20Inventory%20Database%20Documentation.md)
-   [Business Rule Documentation](../../docs/PIFSC%20Resource%20Inventory%20-%20Business%20Rule%20Documentation.md)
    -   [Business Rule List](../../docs/PRI%20Business%20Rule%20List.xlsx)
-   [Add or Remove Project SOP](../../docs/PIFSC%20Resource%20Inventory%20-%20Add%20or%20Remove%20Project%20SOP.md)

## Requirements:
-   PHP 5.x or higher (tested with PHP5.5 and PHP8)
    -   Required PHP Libraries:
        -   php_openssl.dll (required for retrieving the GitLab/GitHub project information via SSL protocol)
        -   php_oci8_11g.dll (required for interaction with the Oracle database)
        -   php_curl.dll (required for REST API requests to GitLab/GitHub servers)
-   Oracle 12c or higher

## Data Flow:
-   [Data Flow Diagram (DFD)](../../docs/DFD/PRI_DFD.drawio.png)
-   [DFD Documentation](../../docs/DFD/PIFSC%20Resource%20Inventory%20Data%20Flow%20Diagram%20Documentation.md)

## Database Setup:
-   [Installing or Upgrading the Database](../../docs/PIFSC%20Resource%20Inventory%20-%20Installing%20or%20Upgrading%20the%20Database.md)

## Additional script setup:
-   Clone the PHP Shared Library repository to a local directory
    -   Version Control Information:
        -   URL: git@picgitlab.nmfs.local:centralized-data-tools/php-shared-library.git
        -   App: 1.11 (Git tag: php_shared_libary_v1.11)
-   The [retrieve_gitlab_info.bat](../application_code/retrieve_gitlab_info.bat) file has been configured based on the assumption that the PHP5.5 installation directory is c:/web/PHP5.5 and the php.ini file is in the same folder.  If the PHP installation directory and php.ini files are in different directories update the retrieve_gitlab_info.bat file accordingly
    -   This batch file can be executed on-demand or on a specified schedule to process the GIM to refresh the PRI database with the project information from the PIFSC GitLab server
-   Update the [constants.php](../application_code/constants.php) configuration file to specify the information listed below:
    -   APPLICATION_INCLUDE_PATH is the directory location path of the working copy of the PRI repository for the GIM's application_code folder
    -   SHARED_LIBRARY_INCLUDE_PATH is the directory location path for the local working copy of the PHP Shared Library
    -   GITLAB_HOST_NAME can remain unchanged
    -   GITLAB_API_KEY is the API key for the PIFSC GitLab server
    -   PROJ_SOURCE can remain unchanged
-   Update the [db_connection_info.php](../application_code/functions/db_connection_info.php) configuration file to specify the hostname/username/password for the application schema (PRI_RIA_APP) used for database interactions

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
