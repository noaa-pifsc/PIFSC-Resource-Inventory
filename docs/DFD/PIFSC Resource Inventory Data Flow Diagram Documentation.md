# PIFSC Resource Inventory Data Flow Diagram Documentation

## Overview:
A data flow diagram (DFD) is a visual representation of a data system intended to make it easier to understand by defining the system in terms of processes, inputs, and outputs.  DFDs can be used to identify improvements to existing processes and opportunities to implement new processes to enhance the overall system.  This document describes the PIFSC Resource Inventory (PRI) DFD that maps the flow of data in relation to the PRI data system.  

## Resources:
-   [PRI DFD](./PRI_DFD.drawio) (draw.io source file)
    -   [PRI DFD Image](./PRI_DFD.drawio.png)
-   [PRI Database documentation](../PIFSC%20Resource%20Inventory%20Database%20Documentation.md)

## Process:
-   The PRI Git Info Module (GIM) requests PIFSC project, tag, etc. information from the PIFSC GitLab and GitHub servers and refreshes the PRI database.
-   The PRI database can be queried directly by authorized PIFSC users
-   The PRI Web App queries the project information from the PRI database and displays it in HTML format, the app can be accessed by authorized PIFSC users
-   The Pacific Islands (PI) Data Enterprise Google Site embeds content from the PRI Web App directly in specific pages of the site that can be accessed by authorized PIFSC users
