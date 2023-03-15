# ODS Docker User Documentation

## Overview
The [ODS Data Export Module (ODE)](./ODS%20Data%20Export%20Module%20documentation.md) and [ODS Report Generator Module (ORG)](./ODS%20Report%20Generator%20Technical%20Documentation.md) were implemented as a web application for ease of use.  The ODS docker implementation provides a web page to initiate the request on-demand for the ODE and ORG execution in sequence and users can download existing reports too.

## Application URLs:
-   Test Application: https://ahi.pifsc.gov/odsrptsd
-   Production Application: <TBD>

## Requirements:
-   A connection to the PIFSC network is required to access the application
-   Google Chrome must be used to access the application in order to avoid PIFSC SSL certificate issues

## Automated Report Generation
-   The ODS Docker Project will automatically run at 5 AM on Mondays to generate the ODS reports.  The zip file for each set of ODS reports will be available on the web application

## Report Generation/Download Procedure
-   Login to the web application using NOAA ICAM credentials
    -   The username is your NOAA email address without the "@noaa.gov" and the password is your email password)
-   After a successful login by an authorized user the user will see a list of zip files that contain the .csv data export and the custom formatted reports for a given date
    -   Users can click on any filename to download the zip file
-   To generate the ODS reports on-demand click the "Generate Reports" button to initiate the ODE and then the ORG
    -   \*Note: this process can take up to 30 minutes
    -   Download the zip file when prompted, the .csv data export and the custom formatted reports will be contained in the zip file
-   When the user is finished downloading the ODS reports they can click the logout link

## User Authorization Procedure
-   The user must have an active NOAA email account
-   The user must be granted the "ODS_ADMIN" role using the AAM (contact application administrator to obtain access)
