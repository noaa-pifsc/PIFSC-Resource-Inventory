# PIFSC Resource Inventory Docker Application User Documentation

## Overview
The [PIFSC Resource Inventory (PRI) Git Info Module (GIM)](../GIM/docs/PIFSC%20Resource%20Inventory%20Git%20Info%20Module%20-%20Technical%20Documentation.md) and [PRI Resource Inventory Application (RIA)](../RIA/docs/PIFSC%20Resource%20Inventory%20Resource%20Inventory%20Application%20-%20Technical%20Documentation.md) were implemented as a [docker](https://www.docker.com/) container to make the application portable and not require users to install anything on their computers to run the two PRI modules.  The PRI docker implementation provides a cron job to execute the GIM to refresh the PRI database and the RIA web application to access the PRI database information.

## Application URLs:
-   Test Application: https://ahi.pifsc.gov/pirri/
-   Production Application: <TBD>

## Requirements:
-   A connection to the PIFSC network is required to access the application
-   Users
    -   Google Chrome must be used to access the application in order to avoid PIFSC SSL certificate issues

## Features:
-   Installed modules and database features (see [Database Documentation](./PIFSC%20Resource%20Inventory%20Database%20Documentation.md))

## Web Application
-   Web Pages:
    -   Summary Reports (index.php)
        -   This page contains summary information about projects and resources
    -   View All Projects (view_all_projects.php)
        -   This page lists all projects with links to the corresponding version control system and associated resources.  
        -   The page allows users to filter projects by their Project Source and also provides a full text search.  Clicking the "Filter Projects" button will refresh the page with the corresponding list of filtered projects
    -   View Project (view_project.php)
        -   This page shows a specific project with links to the corresponding version control system and associated resources.
    -   View All Resources (view_all_resources.php)
        -   This page lists all resources with links to the corresponding version control system and associated projects.  
        -   The page allows users to filter resources by their Resource Scope, Resource Type, Project Source and also provides a full text search.  Clicking the "Filter Projects" button will refresh the page with the corresponding list of filtered resources
    -   View Resource (view_resource.php)
        -   This page shows a specific resource with links to the corresponding version control system and associated projects.
