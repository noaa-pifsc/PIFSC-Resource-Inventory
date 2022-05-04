# PIFSC Resource Inventory Resource Inventory App - Technical Documentation

## Overview:
The PIFSC Resource Inventory (PRI) Resource Inventory App (RIA) was developed to display project and resource information from GitLab and GitHub version control systems that is refreshed in a local database.

## Resources:
-   Version Control Information:
    -   URL:git@gitlab.pifsc.gov:centralized-data-tools/pifsc-resource-inventory.git in the [GIM](../) folder
    -   Application: 0.2 (Git tag: pifsc_resource_inventory_git_info_app_v0.2)
-   [PRI Database Documentation](../../docs/PIFSC%20Resource%20Inventory%20Database%20Documentation.md)

## Requirements:
-   PHP 5.x
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
        -   URL: git@gitlab.pifsc.gov:centralized-data-tools/php-shared-library.git
        -   Version: 1.11 (Git tag: php_shared_libary_v1.11)

## Application Security:
-   [Principle of least privilege](https://docs.google.com/document/d/15qW2pDHM8bebmNJ76AfC-SgICKQPGmKSiUkXbrZ7OVQ/edit?usp=sharing): All of the data tables and support objects are defined in the PRI data schema (PRI), the GIM's parsing schema (shadow schema) which is used to actually interact with the underlying database is PRI_RIA_APP. PRI_RIA_APP has very limited permissions on the PRI schema based on the required functionality of the application (see [PRI_RIA_APP_permissions.xlsx](./PRI_RIA_APP_permissions.xlsx)) to implement the principle of least privilege. The PRI_RIA_APP schema has not been granted any roles in the database instance.
