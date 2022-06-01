# PIFSC Resource Inventory Resource Inventory App - Technical Documentation

## Overview:
The PIFSC Resource Inventory (PRI) Resource Inventory App (RIA) was developed to display project and resource information from GitLab and GitHub version control systems that is refreshed in a local database.

## Resources:
-   Version Control Information:
    -   URL:git@picgitlab.nmfs.local:centralized-data-tools/pifsc-resource-inventory.git in the [RIA](../) folder
    -   Application: 0.2 (Git tag: pifsc_resource_inventory_res_inv_app_v0.2)
-   [PRI Database Documentation](../../docs/PIFSC%20Resource%20Inventory%20Database%20Documentation.md)
-   [Business Rule Documentation](../../docs/PIFSC%20Resource%20Inventory%20-%20Business%20Rule%20Documentation.md)
    -   [Business Rule List](../../docs/PRI%20Business%20Rule%20List.xlsx)

## Requirements:
-   PHP 5.x or higher (tested with PHP5.5 and PHP8)
-   Oracle 12c or higher

## Data Flow:
-   [Data Flow Diagram (DFD)](../../docs/DFD/PRI_DFD.drawio.png)
-   [DFD Documentation](../../docs/DFD/PIFSC%20Resource%20Inventory%20Data%20Flow%20Diagram%20Documentation.md)

## Requirements:
-   Required PHP Libraries:
    -   php_oci8_11g.dll (required for interaction with the Oracle database)

## Additional script setup:
-   Clone the PHP Shared Library repository to a local directory
    -   Version Control Information:
        -   URL: git@picgitlab.nmfs.local:centralized-data-tools/php-shared-library.git
        -   Version: 1.11 (Git tag: php_shared_libary_v1.11)
-   Update the [constants.php](../application_code/constants.php) configuration file to specify the information listed below:
    -   APPLICATION_INCLUDE_PATH is the directory location path of the working copy of the PRI repository for the GIM's application_code folder
    -   SHARED_LIBRARY_INCLUDE_PATH is the directory location path for the local working copy of the PHP Shared Library
    -   SHARED_LIBRARY_CLIENT_PATH is relative directory location path for the local working copy of the PHP Shared Library (this is used for the client-side files like .css and .js)
-   Update the [db_connection_info.php](../application_code/functions/db_connection_info.php) configuration file to specify the hostname/username/password for the application schema (PRI_RIA_APP) used for database interactions

## Database Setup:
-   [Installing or Upgrading the Database](../../docs/PIFSC%20Resource%20Inventory%20-%20Installing%20or%20Upgrading%20the%20Database.md)

## Business Rules:
-   The business rules for the RIA are defined in the [Business Rule Documentation](../../docs/PIFSC%20Resource%20Inventory%20-%20Business%20Rule%20Documentation.md) and each specific business rule listed in the [Business Rule List](../../docs/PRI%20Business%20Rule%20List.xlsx) with a Scope of "RIA" apply to this module and each rule with a Scope of "PRI Database" apply to the underlying database

## Application Security:
-   [Principle of least privilege](https://docs.google.com/document/d/15qW2pDHM8bebmNJ76AfC-SgICKQPGmKSiUkXbrZ7OVQ/edit?usp=sharing): All of the data tables and support objects are defined in the PRI data schema (PRI), the GIM's parsing schema (shadow schema) which is used to actually interact with the underlying database is PRI_RIA_APP. PRI_RIA_APP has very limited permissions on the PRI schema based on the required functionality of the application (see [PRI_RIA_APP_permissions.xlsx](./PRI_RIA_APP_permissions.xlsx)) to implement the principle of least privilege. The PRI_RIA_APP schema has not been granted any roles in the database instance.
