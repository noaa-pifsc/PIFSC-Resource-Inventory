# PIFSC Resource Inventory Project Features

## Overview
This document contains a list of potential features for the PIFSC Resource Inventory project

## Resources
-   [Readme](../README.md)

## Features:
-   Utilize the X GitLab and _ GitHub API to pull Git project information into a database that can be used to provide information to folks directly in the DB
-   X Web interface (also allows data to be embedded directly in web pages)
-   X Version Control URLs (SSH/web page)
-   Last update
-   X Filter out private projects
-   X Project Description/Name
-   _ retrieve more information from the API (like top contributor, last contributor, project owner, etc.)
    -   first commit/last commit
    -   last update
    -   last contributor
    -   number of commits
    -   owner
-   X Standardize tagging strategy: Query the Git Lab server for each instance of a GitLab tag that matches a version of the given tag for a project (e.g. template application has version 1.0 of the DB version control module installed) - we could have a list of dependencies that people can see (color coded or other visual representation)
    -   X This will help to provide information about how often a given software module/SOP has been utilized by specific data projects
-   Standardize the README.md so specific information can be pulled into the DB from different sections
-   X Create a specific file that contains PIFSC Resource Inventory configuration information like display color, associating tags with versions of SOPs, Tools, DBs, etc.
    -   Principle: make it quick and easy to add the given repository project to the PRI system and allow configuration options.  This can identify multiple resources in a given project
    -   e.g. PRI.config (the presence of this file could also serve as the opt-in) maybe do a JSON file to make it flexible
    -   tag naming conventions (e.g. facilities_tracking_db_v, db_vers_ctrl_v) to allow the most recent version to be provided to user
        -   tag naming conventions should be handled to escape special characters when used in regular expressions
    -   Production/ X Demo URLs
    -   Flag to indicate the resource is in production
    -   there should be a distinction between if a given soln is implemented or just installed (e.g. folks who use the template application will have the DVM installed by default but may not actually be using it -> e.g Personnel Tracking System)
    -   Opt-in to include the project in the inventory
    -   X Category (e.g. Data Management, Software Development, etc.)
    -   X Resource Types: Software Tool/SOP
    -   Platform/Software
-   Can refresh DB using an Oracle job on a daily basis so data is reasonably up-to-date
-   implement RSS feeds or something similar to notify subscribed folks when there is a new resource upgrade available
-   Compile SOP for the different project/resource scenarios (including git tagging rules)
    -   X Compile SOP for generating JSON configuration files:
        -   provide JSON file template
        -   provide excel template for generating JSON content
        -   provide JSON file schema for verifying the generated JSON
-   Embed the web app in the Data Enterprise Google Site
-   Implement searching/filtering functionality on the projects/resources pages so people can search, filter and sort the results in a variety of ways to find what they need
-   Build the view resource and view project pages for a specific record.
-   Allow multiple scopes to be defined for a given resource (e.g. PRI is a DG, DS, and SW resource)
-   Deploy internally for review/feedback
-   Implement GitHub API to pull the same information from the public repositories I deployed (PIFSC Org only for now)
-   Implement static resources that don’t come from a version control system (e.g. data history creator, Google Docs, etc.)
    -   Can potentially interface with the Documan system that Sunny developed for non-Git resources.  We would just pull the SOPs that are marked as SW, DS, or DG
-   Compile SOP for including projects/resources in PRI
-   Need to also allow authorized folks to edit static resources or upload the updated information somehow (phase 3-4 probably)
