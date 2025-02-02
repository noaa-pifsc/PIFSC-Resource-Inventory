# PIFSC Resource Inventory Database Documentation

## Overview:
This database provides the core database objects required to run the PIFSC Resource Inventory (PRI) modules. Project information The PRI database incorporates reusable database modules to perform the associated functions in the application. The reusable modules facilitate the associated standards and best practices as well as code reusability.

## Resources:
-   PRI Version Control Information:
    -   URL:git@picgitlab.nmfs.local:centralized-data-tools/pifsc-resource-inventory.git
    -   Database: 1.0 (Git tag: pifsc_resource_inventory_db_v1.0)
-   [View Comments](PRI_view_comments.xlsx)
-   [PRI Database Naming Conventions](PIFSC%20Resource%20Inventory%20DB%20Naming%20Conventions.md)
-   [PL/SQL Coding Conventions](./PIFSC%20Resource%20Inventory%20-%20PLSQL%20Coding%20Conventions.md)
-   [PRI Database Diagram](data_model/PRI_DB_diagram.pdf)
    -   [Documentation](PIFSC%20Resource%20Inventory%20DB%20Diagram%20Documentation.md)
-   [PRI View Comments](./PRI_view_comments.xlsx)
-   [PRI Data Flow Diagram (DFD)](DFD/PRI_DFD.drawio.png)
    -   [Documentation](DFD/PIFSC%20Resource%20Inventory%20Data%20Flow%20Diagram%20Documentation.md)
-   [PRI Git Info Module (GIM) - Technical Documentation](../GIM/docs/PIFSC%20Resource%20Inventory%20Git%20Info%20Module%20-%20Technical%20Documentation.md)
-   [PRI Resource Inventory App (RIA) - Technical Documentation](../RIA/docs/PIFSC%20Resource%20Inventory%20Resource%20Inventory%20Application%20-%20Technical%20Documentation.md)
-   [Business Rule Documentation](./PIFSC%20Resource%20Inventory%20-%20Business%20Rule%20Documentation.md)
    -   [Business Rule List](./PRI%20Business%20Rule%20List.xlsx)

## Database Setup:
-   Create two separate database schemas for the database (data schema) and one for each application module (application/shadow schema)
    -   [Oracle Resource Request SOP](https://docs.google.com/document/d/1cSru4Cy7Ccl3sd-3UrOFb5cqmOPtzjd0khG1lX0VSE0/edit#bookmark=kix.87qwoqx35jfc)
-   [Installing or Upgrading the Database](./PIFSC%20Resource%20Inventory%20-%20Installing%20or%20Upgrading%20the%20Database.md)
    -   \*\*Note: the scripts to create/upgrade the database objects are executed on the data schema (PRI)

## Features:
-   The DB Module Packager (DMP) project was utilized to streamline the installation of the custom database modules listed below:
    -   Version Control Information:
        -   Repository URL: git@picgitlab.nmfs.local:centralized-data-tools/db-module-packager.git
        -   DMP Version: 0.4 (git tag: db_module_packager_v0.4)
        -   The DMP Scientific Database use case was implemented on the PRI
            -   Database: 1.0 (Git tag: DMP_Scientific_v1.0)
-   DB Version Control Module (VCM)
    -   Repository URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBVersionControlModule.git
    -   Database Version: 0.2 (git tag: db_vers_ctrl_db_v0.2)
    -   SOP Version: 1.0 (git tag: db_vers_ctrl_v1.0)
-   DB Logging Module (DLM)
    -   Repository URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DBLoggingModule.git
    -   Version: 0.3 (git tag: db_log_db_v0.3)
-   Data Validation Module (DVM)
    -   Repository URL: git@github.com:PIFSC-NMFS-NOAA/PIFSC-DataValidationModule.git
    -   Version: 1.4 (git tag: DVM_db_v1.4)

## Business Rules:
-   The business rules for the PRI are defined in the [Business Rule Documentation](./PIFSC%20Resource%20Inventory%20-%20Business%20Rule%20Documentation.md) and each specific business rule listed in the [Business Rule List](./PRI%20Business%20Rule%20List.xlsx) with a Scope of "PRI Database" apply to the underlying database
