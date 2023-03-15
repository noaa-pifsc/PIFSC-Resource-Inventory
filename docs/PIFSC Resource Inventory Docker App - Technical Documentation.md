# ODS Docker Application Technical Documentation

## Overview
The [ODS Data Export Module (ODE)](./ODS%20Data%20Export%20Module%20documentation.md) and [ODS Report Generator Module (ORG)](./ODS%20Report%20Generator%20Technical%20Documentation.md) were implemented as the ODS Docker App (ODS) using [docker](https://www.docker.com/) to make the application portable and not require users to install anything on their computers to run the two ODS modules.  The ODS docker implementation provides a web page to initiate the request on-demand for the ODE and ORG execution in sequence.

## Resources:
-   Version Control Information:
    -   URL: <git@picgitlab.nmfs.local:centralized-data-tools/parr-tools.git> in the "ODS" folder
    -   Application: 1.1 (Git tag: ODS_docker_app_v1.1)
-   [End User Documentation](./ODS%20Docker%20App%20User%20Documentation.md)
-   [Data Set Database (DSD) Documentation](../../docs/PIR%20Data%20Set%20Database%20Documentation.md)

## Application URLs:
-   Dev Application: https://localhost:5015/
-   Test Application: https://ahi.pifsc.gov/odsrptsd/
-   Production Application: <TBD>

## Requirements:
-   A connection to the PIFSC network is required to access the application
-   Users
    -   Google Chrome must be used to access the application in order to avoid PIFSC SSL certificate issues
-   Developers/System Administrators
    -   Docker host platform

## Features:
-   Installed Modules (see [Database Documentation](../../docs/PIR%20Data%20Set%20Database%20Documentation.md) for more information)
-   ICAM Login via [Authorization Application Module (AAM)](https://picgitlab.nmfs.local/centralized-data-tools/authorization-application-module)
-   Database features are listed in the [Database Documentation](../../docs/PIR%20Data%20Set%20Database%20Documentation.md)

## Setup:
-   clone the [PARR Tools repository](https://picgitlab.nmfs.local/centralized-data-tools/parr-tools) into a local folder
-   Edit the appropriate deployment script (e.g. [prepare_docker_project.dev.sh](../docker/deployment_scripts/prepare_docker_project.dev.sh) for the development version) and docker build/deploy script (e.g. [build_deploy_project.dev.sh](../docker/deployment_scripts/build_deploy_project.dev.sh) for the development version) shell scripts to define the "root_directory" variable value to a local directory that can be used to build the image
    -   Execute the appropriate deployment script (e.g. [prepare_docker_project.test.sh](../docker/deployment_scripts/prepare_docker_project.test.sh) for the test version) shell script to deploy the docker project files to a given directory
-   Development Deployments (PICV014 - localhost)
    -   Edit the database connection details for the corresponding database instance:
        -   Edit the SQLPlus credentials file ($root_directory/docker/odsrptsdev/backend/SQL/credentials/dev_ODS_credentials.sql) to replace the [PASSWORD] placeholder with the PICDM schema database password
        -   Edit the PHP credentials file ($root_directory/docker/odsrptsdev/backend/includes/ods_db_connection_info.php) to define the DB_PASS constant as the password for the PICDM_ODS_APP schema database password
    -   \*Note: to facilitate rapid development a bind mount version of the development deployment script is available ([prepare_docker_project.dev.mount.sh](../docker/deployment_scripts/prepare_docker_project.dev.mount.sh)) to mount the www and backend folders from the exported docker project directory in the docker container so that changes to the docker project directory are reflected in the running container
    -   Execute the [build_deploy_project.dev.sh](../docker/deployment_scripts/build_deploy_project.dev.sh) shell script to build and deploy the docker project
-   Test Deployments (docker host machine: ahi.pifsc.gov)
    -   Edit the database connection details for the corresponding database instance:
        -   Edit the SQLPlus credentials file (e.g. $root_directory/docker/odsrptsd/backend/SQL/credentials/test_ODS_credentials.sql) to replace the [PASSWORD] placeholder with the PICDM schema database password
        -   Edit the PHP credentials file ($root_directory/docker/odsrptsd/backend/includes/ods_db_connection_info.php) to define the DB_PASS constant as the password for the PICDM_ODS_APP schema database password
    -   Using an SFTP client copy all exported docker project files (e.g. $root_directory/docker/odsrptsd) to the test docker host machine in the /tmp/[user] folder where [user] is the username for the ssh account  
    -   SSH into the docker host machine (ahi.pifsc.gov)
    -   Change to the temporary docker project files directory
```
cd /tmp/[user] where [user] is the username for the ssh account
```
    -   Update permissions on temporary docker project files
```
chmod -R 755 *
```
    -   Switch to the webd docker user
```
sudo su - webd
```
    -   switch to the odsrptsd docker source directory
```
cd docker/odsrptsd/
```
    -   remove the existing files in the odsrptsd docker source directory
```
rm -rf *
```
    -   copy the temporary docker project files to the odsrptsd docker source directory where [user] is the username for the ssh account
```
rsync -aP /tmp/[user]]/* ./
```
    -   (if the docker container is already running) stop the container
```
sudo docker-compose down
```
    -   create and deploy the docker container
```
sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build
```
-   Production Deployments (docker host machine: ahi.pifsc.gov)
    -   Edit the database connection details for the corresponding database instance:
        -   Edit the SQLPlus credentials file (e.g. $root_directory/docker/odsrptsdev/parr-tools/ODS/SQL/credentials/prod_ODS_credentials.sql) to replace the [PASSWORD] placeholder with the PICDM schema database password
        -   Edit the PHP credentials file ($root_directory/docker/odsrptsdev/parr-tools/ODS/application_code/ods_db_connection_info.php) to define the DB_PASS constant as the password for the PICDM_ODS_APP schema database password
    -   <mark>(Process is TBD)

# Server Instance Configurations
-   Each server instance has its own set of server-specific configuration files that are automatically used when the corresponding deployment script is used, the following is a list of those files.  Update the corresponding version of the given file to update the configuration for the corresponding server instance:
    -   Dockerfile - this is the docker image file used to specify the resources used when building the docker image (e.g. [Dockerfile.prod](../docker/config/Dockerfile.prod) for the production app server)
    -   docker-compose.yml - this is the docker compose configuration file used to specify the image building configuration of the docker image (e.g. [docker-compose.test.yml](../docker/config/docker-compose.prod.test.yml) for the test app server)
    -   docker-compose.prod.yml - this is the docker compose configuration file used to specify the runtime configuration of the docker container (e.g. [docker-compose.prod.dev.yml](../docker/config/docker-compose.prod.dev.yml) for the development app server)
    -   constants.php - this is the PHP application's configuration file to specify application constant values used during runtime (e.g. [constants.prod.php](../application_code/constants.prod.php) for the production app server)
    -   httpd.conf - this is the apache server's configuration file (e.g. [httpd.test.conf](../docker/config/httpd.test.conf) for the test app server)
    -   php.ini - this is the PHP runtime configuration file (e.g. [php.dev.ini](../docker/config/php.dev.ini) for the development app server)

## Cron Job Setup
-   The [ods_crontab.txt](../docker/config/ods_crontab.txt) contains the definition for the cron job
-   The cron job log is located in /usr/src/ODS/logs/cron.log
-   The cron job script ([generate_ods_data.sh](../docker/config/generate_ods_data.sh)) is executed each time the cron job runs

## Web Application Algorithm
-   Due to the performance issues with the ODS data source a method was developed as a workaround to the web proxy or apache server request timeouts.  
-   The initial on-demand web request will send an ajax request to index.php with the execute_ods POST variable defined and wait for a response
    -   The index page generates a random hex string as a unique request ID and initiates the [cli_ods_generator.php](../application_code/functions/cli_ods_generator.php) script using a shell script command and returns the process ID to the index.php page
        -   The shell script runs as a background process to execute the ODE and ORG and writes the results of the processing to a temporary log file
    -   The index page generates a JSON response to the initial ajax request to provide the process ID and request ID and returns it to the web browser
-   The ajax handler parses the process ID and request ID and stores them in local variables
-   The web browser waits for 20 seconds and then sends an ajax request to the check_process_status.php listener page with the process ID and request ID as parameters
    -   The listener page validates that the user is logged in and authorized to make the request and if the parameters have been specified, if not it returns JSON to the web browser with error information
    -   If the request is valid then the listener will check if the system process ID is still running, if so then it will return JSON to the web browser to indicate the process is still running
		-   If the process is not still running then the listener reads the log file and returns the information in JSON format to indicate the process has finished that contains the processing results
-   The web browser will parse the json response,
    -   If there was an error it will print out the error and stop any subsequent ajax requests.  
    -   If the request was successful then it will print the processing results and stop any subsequent requests.  
    -   If the process is still running it will wait 20 seconds and send another ajax request to check_process_status.php to see if the process has finished

## Business Rules
-   The web application only lists previously generated zip file downloads from the last two months (based on the date value in the file name in YYYYMMDD format), older files are not displayed in the index.php page

## Docker Volumes
-   odsrptsd_ods_data contains the generated csv data files, formatted excel files, zip files generated by the ODE and ORG
-   odsrptsd_ods_logs contains the logs generated by the ODE, ORG and cron job

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
-   The user must be granted the "ODS_ADMIN" role using the AAM ([documentation link](https://picgitlab.nmfs.local/centralized-data-tools/authorization-application-module/-/blob/master/docs/Authorization%20Application%20Module%20Documentation.md#defining-users-and-permissions-groups))

## Security:
-   Application Security
    -   [Principle of least privilege](https://docs.google.com/document/d/15qW2pDHM8bebmNJ76AfC-SgICKQPGmKSiUkXbrZ7OVQ/edit?usp=sharing): All of the data tables and support objects are defined in the PICDM data schema, the APEX application's parsing schema (shadow schema) which is used to actually interact with the underlying database is PICDM_ODS_APP. PICDM_ODS_APP has very limited permissions on the PICDM schema based on the required functionality of the application (shown in [PICDM_ODS_APP Permissions](PICDM_ODS_APP_permissions.xlsx)) to implement the principle of least privilege.
    -   \*Note: the ODE still uses PICDM to connect since the ODS database link is defined on the PICDM schema, but the database logging and ICAM login are performed using the PICDM_ODS_APP schema
