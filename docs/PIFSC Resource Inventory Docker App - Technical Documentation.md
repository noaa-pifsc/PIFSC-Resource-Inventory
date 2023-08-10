# PIFSC Resource Inventory Docker Application Technical Documentation

## Overview
The [PIFSC Resource Inventory (PRI) Git Info Module (GIM)](../GIM/docs/PIFSC%20Resource%20Inventory%20Git%20Info%20Module%20-%20Technical%20Documentation.md) and [PRI Resource Inventory Application (RIA)](../RIA/docs/PIFSC%20Resource%20Inventory%20Resource%20Inventory%20Application%20-%20Technical%20Documentation.md) were implemented as a [docker](https://www.docker.com/) container to make the application portable and not require users to install anything on their computers to run the two PRI modules.  The PRI docker implementation provides a cron job to execute the GIM to refresh the PRI database and the RIA web application to access the PRI database information.

## Resources:
-   Version Control Information:
    -   URL: <git@picgitlab.nmfs.local:centralized-data-tools/parr-tools.git> in the "PRI" folder
    -   Application: 1.4 (Git tag: PRI_docker_app_v1.4)
-   [End User Documentation](./PIFSC%20Resource%20Inventory%20Docker%20App%20-%20User%20Documentation.md)
-   [PRI Database Documentation](./PIFSC%20Resource%20Inventory%20Database%20Documentation.md)
-   [GIM Documentation](../GIM/docs/PIFSC%20Resource%20Inventory%20Git%20Info%20Module%20-%20Technical%20Documentation.md)
-   [RIA Documentation](../RIA/docs/PIFSC%20Resource%20Inventory%20Resource%20Inventory%20Application%20-%20Technical%20Documentation.md)
-   [Docker Project Testing Documentation](./PIFSC%20Resource%20Inventory%20Docker%20App%20Testing%20Documentation.md)

## Requirements:
-   A connection to the PIFSC network is required to access the application
-   Developers/System Administrators
    -   Docker host platform

## Features:
-   Installed modules and database features (see [Database Documentation](./PIFSC%20Resource%20Inventory%20Database%20Documentation.md))

## Setup:
-   #### Database Setup
    -   [Installing or Upgrading the Database](./PIFSC%20Resource%20Inventory%20-%20Installing%20or%20Upgrading%20the%20Database.md)
-   #### Docker Application Setup
    -   ##### Project Preparation
        -   clone the [PRI repository](https://picgitlab.nmfs.local/centralized-data-tools/pifsc-resource-inventory) into a local folder
        -   Edit the appropriate deployment script (e.g. [prepare_docker_project.dev.sh](../docker/deployment_scripts/prepare_docker_project.dev.sh) for the development version) and docker build/deploy script (e.g. [build_deploy_project.dev.sh](../docker/deployment_scripts/build_deploy_project.dev.sh) for the development version) shell scripts to define the "root_directory" variable value to a local directory that can be used to build the image
            -   Execute the appropriate preparation script (e.g. [prepare_docker_project.test.sh](../docker/deployment_scripts/prepare_docker_project.test.sh) for the test version) shell script to deploy the docker project files to a given directory
            -   \*Note: the preparation script will clone the necessary repositories into the corresponding "root_directory" folder and use the appropriate configuration files for the corresponding folder structure to prepare the docker project for deployment  
    -   ##### Development Deployments
        -   \*Note: the docker host is the docker desktop instance used for development
        -   Edit the database connection details for the corresponding database instance:
            -   (GIM) Edit the PHP credentials file ($root_directory/docker/pirridev/backend/GIM/includes/db_connection_info.php) to define the DB_PASS constant as the password for the PRI_GIM_APP schema database password
            -   (GIM) Edit the PHP constants file ($root_directory/docker/pirridev/backend/GIM/includes/gitlab_config.php) to define the GITLAB_API_KEY constant to a GitLab access token with "read_api" privileges
            -   (RIA) Edit the PHP credentials file ($root_directory/docker/pirridev/backend/RIA/includes/db_connection_info.php) to define the DB_PASS constant as the password for the PRI_RIA_APP schema database password
        -   \*Note: to facilitate rapid development a bind mount version of the development deployment script is available ([prepare_docker_project.dev.mount.sh](../docker/deployment_scripts/prepare_docker_project.dev.mount.sh)) to mount the www and backend folders from the exported docker project directory in the docker container so that changes to the docker project directory are reflected in the running container
        -   Execute the [build_deploy_project.dev.sh](../docker/deployment_scripts/build_deploy_project.dev.sh) shell script to build and deploy the docker project
    -   ##### Test Deployments 
        -   \*Note: docker host machine: picahi.nmfs.local
        -   Edit the database connection details for the corresponding database instance:
            -   (GIM) Edit the PHP credentials file ($root_directory/docker/pirrid/backend/GIM/includes/db_connection_info.php) to define the DB_PASS constant as the password for the PRI_GIM_APP schema database password
            -   (GIM) Edit the PHP constants file ($root_directory/docker/pirrid/backend/GIM/includes/gitlab_config.php) to define the GITLAB_API_KEY constant to a GitLab access token with "read_api" privileges
            -   (RIA) Edit the PHP credentials file ($root_directory/docker/pirrid/backend/RIA/includes/db_connection_info.php) to define the DB_PASS constant as the password for the PRI_RIA_APP schema database password
        -   Copy all exported docker project files 
            -   Open SSH method (Windows)
                -   Open command line windows
                -   Change to the temporary exported docker directory (e.g. [root_directory]/docker/pirrid) where [root_directory] is the root directory for the exported temporary exported docker directory
                    -   ```
                        cd [root_directory]/docker/pirrid
                        ```
                -   copy the files to the /tmp/[user] directory where [user] is the username for the ssh account
                    -   ```
                        scp -rp ./ [user]@picahi.nmfs.local:/tmp/[user]
                        ```

                -   Enter the SSH password for the docker host server
            -   SFTP client method
                -   Using an SFTP client copy all exported docker project files (e.g. $root_directory/docker/pirrid) to the test docker host machine in the /tmp/[user] folder where [user] is the username for the ssh account  
        -   SSH into the docker host machine (picahi.nmfs.local)
        -   Change to the temporary docker project files directory
            -   ```
                cd /tmp/[user] where [user] is the username for the ssh account
                ```
        -   Update permissions on temporary docker project files
            -   ```
                chmod -R 755 *
                ```
        -   Switch to the webd docker user
            -   ```
                sudo su - webd
                ```
        -   switch to the pirrid docker source directory
            -   ```
                cd docker/pirrid/
                ```
        -   remove the existing files in the pirrid docker source directory
            -   ```
                rm -rf *
                ```
        -   copy the temporary docker project files to the pirrid docker source directory where [user] is the username for the ssh account
            -   ```
                rsync -aP /tmp/[user]]/* ./
                ```
        -   (if the docker container is already running) stop the container
            -   ```
                sudo docker-compose down
                ```
        -   create and deploy the docker container
            -   ```
                sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build
                ```
    -   ##### Production Deployments
        -   \*Note: docker host machine: picahi.nmfs.local
        -   Edit the database connection details for the corresponding database instance:
            -   (GIM) Edit the PHP credentials file ($root_directory/docker/pirri/backend/GIM/includes/db_connection_info.php) to define the DB_PASS constant as the password for the PRI_GIM_APP schema database password
            -   (GIM) Edit the PHP constants file ($root_directory/docker/pirri/backend/GIM/includes/gitlab_config.php) to define the GITLAB_API_KEY constant to a GitLab access token with "read_api" privileges
            -   (RIA) Edit the PHP credentials file ($root_directory/docker/pirri/backend/RIA/includes/db_connection_info.php) to define the DB_PASS constant as the password for the PRI_RIA_APP schema database password
        -   Copy all exported docker project files 
            -   Open SSH method (Windows)
                -   Open command line windows
                -   Change to the temporary exported docker directory (e.g. $root_directory/docker/pirri)
                    -   ```
                        cd [root_directory]/docker/pirri where [root_directory] is the root directory for the exported temporary exported docker directory
                        ```
                -   copy the files to the /tmp/[user] directory where [user] is the username for the ssh account
                    -   ```
                        scp -rp ./ [user]@picahi.nmfs.local:/tmp/[user]
                        ```
                -   Enter the SSH password for the docker host server
            -   SFTP client method
                -   Using an SFTP client copy all exported docker project files (e.g. $root_directory/docker/pirri) to the test docker host machine in the /tmp/[user] folder where [user] is the username for the ssh account  
        -   SSH into the docker host machine (picahi.nmfs.local)
        -   Change to the temporary docker project files directory
            -   ```
                cd /tmp/[user] where [user] is the username for the ssh account
                ```
        -   Update permissions on temporary docker project files
            -   ```
                chmod -R 755 *
                ```
        -   Switch to the webd docker user
            -   ```
                sudo su - webd
                ```
        -   switch to the pirri docker source directory
            -   ```
                cd docker/pirri/
                ```
        -   remove the existing files in the pirri docker source directory
            -   ```
                rm -rf *
                ```
        -   copy the temporary docker project files to the pirri docker source directory where [user] is the username for the ssh account
            -   ```
                rsync -aP /tmp/[user]]/* ./
                ```
        -   (if the docker container is already running) stop the container
            -   ```
                sudo docker-compose down
                ```
        -   create and deploy the docker container
            -   ```
                sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build
                ```

# Server Instance Configurations
-   Each server instance has its own set of server-specific configuration files that are automatically used when the corresponding deployment script is used, the following is a list of those files.  Update the corresponding version of the given file to update the configuration for the corresponding server instance:
    -   Dockerfile - this is the docker image file used to specify the resources used when building the docker image (e.g. [Dockerfile.prod](../docker/config/Dockerfile.prod) for the production app server)
    -   docker-compose.yml - this is the docker compose configuration file used to specify the image building configuration of the docker image (e.g. [docker-compose.test.yml](../docker/config/docker-compose.prod.test.yml) for the test app server)
    -   docker-compose.prod.yml - this is the docker compose configuration file used to specify the runtime configuration of the docker container (e.g. [docker-compose.prod.dev.yml](../docker/config/docker-compose.prod.dev.yml) for the development app server)
    -   (RIA) app_instance_config.php - this is the PHP web application's configuration file to specify application instance values used during runtime (e.g. [app_instance_config.dev.php](../RIA/application_code/functions/app_instance_config.dev.php) for the development app server)
    -   httpd.conf - this is the apache server's configuration file (e.g. [httpd.test.conf](../docker/config/httpd.test.conf) for the test app server)
    -   php.ini - this is the PHP runtime configuration file (e.g. [php.dev.ini](../docker/config/php.dev.ini) for the development app server)

## Cron Job Setup
-   The [GIM_crontab.txt](../docker/config/GIM_crontab.txt) contains the definition for the cron job
-   The cron job log is located in /usr/src/PRI/logs/cron.log
-   The GIM script ([run_GIM.sh](../docker/config/run_GIM.sh)) is executed each time the cron job runs

## Docker Volumes
-   pri_logs contains the logs generated by the GIM and cron job

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
