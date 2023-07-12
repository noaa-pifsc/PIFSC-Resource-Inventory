# PIFSC Resource Inventory Docker Application Testing Documentation

## Overview
The [PIFSC Resource Inventory (PRI) Git Info Module (GIM)](../GIM/docs/PIFSC%20Resource%20Inventory%20Git%20Info%20Module%20-%20Technical%20Documentation.md) and [PRI Resource Inventory Application (RIA)](../RIA/docs/PIFSC%20Resource%20Inventory%20Resource%20Inventory%20Application%20-%20Technical%20Documentation.md) were implemented as a [docker](https://www.docker.com/) container to make the application portable and not require users to install anything on their computers to run the two PRI modules.  This document defines the list of application test cases to verify before an upgrade is merged into the main branch and released for formal user acceptance/security testing.

## Resources:
-   [Technical Documentation](./PIFSC%20Resource%20Inventory%20Docker%20App%20-%20Technical%20Documentation.md)
-   [PRI Database Documentation](./PIFSC%20Resource%20Inventory%20Database%20Documentation.md)

## Application Test Cases:
-   Rebuild ODS docker project from scratch
-   GIM Cron Job
    -   test cron job
        -   check cron.log
        -   check DB log
        -   check log file
        -   check DB for updates (refresh date updated)
-   RIA Web App
    -   Summary Reports
        -   Projects/Resources Info Loaded
        -   Tooltips
    -   View All Projects
        -   Filtering 
        -   Tooltips
        -   Project link
        -   Project External link
        -   README Link
        -   Project Resource link
        -   Implemented Resource link
        -   Creator Link
    -   View Project
        -   Tooltips
        -   Project link
        -   Project External link
        -   README Link
        -   Project Resource link
        -   Implemented Resource link
        -   Creator Link
    -   View All Resources
        -   Filtering 
        -   Tooltips
        -   Resource link
        -   Resource External link
        -   Live Demo Link
        -   Implemented Project Links
        -   Project link
        -   Project External link
        -   README Link
        -   Creator Link
    -   View Resource
        -   Tooltips
        -   Resource link
        -   Resource External link
        -   Live Demo Link
        -   Implemented Project Links
        -   Project link
        -   Project External link
        -   README Link
        -   Creator Link
-   (when tests are complete) rebuild ODS docker project with cron job for the actual schedule