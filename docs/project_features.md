# PIFSC Resource Inventory Project Features

## Overview
This document contains a list of potential features for the PIFSC Resource Inventory project

## Resources
-   [Readme](../README.md)

## Features:
-   Utilize the GitLab and GitHub API to pull Git project information into a database that can be used to provide information to folks directly in the DB
-   Web interface (also allows data to be embedded directly in web pages)
-   API for accessing data via tables and views (use Oracle ORDS?)
    -   Version Control URLs (SSH/web page)
    -   Last update
    -   Filter out private projects
    -   Project Description/Name
    -   Standardize tagging strategy: Query the Git Lab server for each instance of a GitLab tag that matches a version of the given tag for a project (e.g. template application has version 1.0 of the DB version control module installed) - we could have a list of dependencies that people can see (color coded or other visual representation)
        -   This will help to provide information about how often a given software module/SOP has been utilized by specific data projects
-   Standardize the README.md so specific information can be pulled into the DB
    -   tag naming conventions (e.g. facilities_tracking_db_v, db_vers_ctrl_v) to allow the most recent version to be provided to user
    -   Production/Demo URLs
    -   Opt-in to include the project in the inventory
    -   Category (e.g. Data Management, Software Development, etc.)
    -   Resource Types: Software Tool/SOP
    -   Platform/Software
-   Another option would be to create a specific file that contains PIFSC Resource Inventory configuration information like display color, associating tags with versions of SOPs, Tools, DBs, etc.
    -   Principle: make it quick and easy to add the given repository project to the PRI system and allow configuration options.  This can identify multiple resources in a given project
    -   e.g. PRI.config (the presence of this file could also serve as the opt-in) maybe do a JSON file to make it flexible
        -   e.g. {"PRI_resource_configuration": [{"tag_naming_convention": "db_vers_ctrl_v", "resource_type": "SOP", "resource_category": "Software", "project_color": "#FFAA00"}, {"tag_naming_convention": "DVM_db_v", "resource_type": "Tool", "resource_category": "Data Management", "project_color": "#AABBCC"}]}
-   Can refresh DB using an Oracle job on a daily basis so data is reasonably up-to-date
