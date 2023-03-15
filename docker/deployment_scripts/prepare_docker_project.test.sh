#! /bin/sh

#development deployment script

echo "running dev deployment script"

root_directory="/c"

mkdir $root_directory/docker
mkdir $root_directory/docker/pirri
mkdir $root_directory/docker/pirri/tmp

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone --branch branch_docker_first_try git@picgitlab.nmfs.local:centralized-data-tools/pifsc-resource-inventory.git $root_directory/docker/pirri/tmp/pifsc-resource-inventory

echo "clone the project dependencies"

git clone git@picgitlab.nmfs.local:centralized-data-tools/php-shared-library.git $root_directory/docker/pirri/tmp/php-shared-library

echo "rename configuration files"

#rename the constants.test.php to constants.php so it can be used as the active configuration file
mv $root_directory/docker/pirri/tmp/pifsc-resource-inventory/GIM/application_code/constants.test.php $root_directory/docker/pirri/tmp/pifsc-resource-inventory/GIM/application_code/constants.php
mv $root_directory/docker/pirri/tmp/pifsc-resource-inventory/RIA/application_code/constants.test.php $root_directory/docker/pirri/tmp/pifsc-resource-inventory/RIA/application_code/constants.php


# remove the test, prod versions of constants.php
rm $root_directory/docker/pirri/tmp/pifsc-resource-inventory/RIA/application_code/constants.dev.php
rm $root_directory/docker/pirri/tmp/pifsc-resource-inventory/RIA/application_code/constants.prod.php
rm $root_directory/docker/pirri/tmp/pifsc-resource-inventory/GIM/application_code/constants.dev.php
rm $root_directory/docker/pirri/tmp/pifsc-resource-inventory/GIM/application_code/constants.prod.php

#rename the httpd.test.conf to httpd.conf so it can be used as the active configuration file
mv $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/httpd.test.conf $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/httpd.conf

#rename the php81-php.test.conf to php81-php.conf so it can be used as the active configuration file
mv $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/php81-php.test.conf $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/php81-php.conf

#rename the php.test.ini to php.ini so it can be used as the active PHP configuration file
mv $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/php.test.ini $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/php.ini



echo "configure docker files"
cp $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/docker-compose.prod.test.yml $root_directory/docker/pirri/tmp/docker-compose.prod.yml
cp $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/docker-compose.test.yml $root_directory/docker/pirri/tmp/docker-compose.yml
cp $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/Dockerfile.test $root_directory/docker/pirri/tmp/Dockerfile


# export the docker project files to make the image smaller

echo "create the web folder structure"
mkdir $root_directory/docker/pirri/www
mkdir $root_directory/docker/pirri/www/res
mkdir $root_directory/docker/pirri/www/php-shared-library
mkdir $root_directory/docker/pirri/www/php-shared-library/css
mkdir $root_directory/docker/pirri/www/php-shared-library/js
mkdir $root_directory/docker/pirri/www/php-shared-library/img

echo "create the backend folder structure"
mkdir $root_directory/docker/pirri/backend
mkdir $root_directory/docker/pirri/backend/scripts
mkdir $root_directory/docker/pirri/backend/RIA
mkdir $root_directory/docker/pirri/backend/RIA/includes
mkdir $root_directory/docker/pirri/backend/GIM
mkdir $root_directory/docker/pirri/backend/php-shared-library
mkdir $root_directory/docker/pirri/backend/config
mkdir $root_directory/docker/pirri/backend/logs


echo "copy the docker files"
cp $root_directory/docker/pirri/tmp/Dockerfile $root_directory/docker/pirri/Dockerfile
cp $root_directory/docker/pirri/tmp/docker-compose.yml $root_directory/docker/pirri/docker-compose.yml
cp $root_directory/docker/pirri/tmp/docker-compose.prod.yml $root_directory/docker/pirri/docker-compose.prod.yml



echo "copy the pifsc-resource-inventory RIA directory"
# copy the pifsc-resource-inventory RIA directory
cp -r $root_directory/docker/pirri/tmp/pifsc-resource-inventory/RIA/application_code/*  $root_directory/docker/pirri/www
# remove the functions folder
rm -rf $root_directory/docker/pirri/www/functions
# remove the logs folder
rm -rf $root_directory/docker/pirri/www/logs


# copy the php-shared-library (.php and .inc files only)
echo "copy the php-shared-library backend directory"
cp -r $root_directory/docker/pirri/tmp/php-shared-library/*.php  $root_directory/docker/pirri/backend/php-shared-library
cp -r $root_directory/docker/pirri/tmp/php-shared-library/*.inc  $root_directory/docker/pirri/backend/php-shared-library
# copy the php-shared library client-side files

echo "copy the php-shared-library client-side directory"
cp -r $root_directory/docker/pirri/tmp/php-shared-library/css/*  $root_directory/docker/pirri/www/php-shared-library/css
cp -r $root_directory/docker/pirri/tmp/php-shared-library/js/*  $root_directory/docker/pirri/www/php-shared-library/js
cp -r $root_directory/docker/pirri/tmp/php-shared-library/img/*  $root_directory/docker/pirri/www/php-shared-library/img



# add in the backend scripts, includes, etc.
cp -r $root_directory/docker/pirri/tmp/pifsc-resource-inventory/RIA/application_code/functions/*  $root_directory/docker/pirri/backend/RIA/includes

cp -r $root_directory/docker/pirri/tmp/pifsc-resource-inventory/GIM/application_code/*  $root_directory/docker/pirri/backend/GIM

# rename the GIM "functions" folder to "includes"
mv $root_directory/docker/pirri/backend/GIM/functions  $root_directory/docker/pirri/backend/GIM/includes





# deploy cron script and crontab definition
cp $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/run_GIM.sh  $root_directory/docker/pirri/backend/scripts
cp $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/GIM_crontab.txt  $root_directory/docker/pirri/backend/config

# copy configuration files:

	# copy the apache/php configuration files:
	cp $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/httpd.conf  $root_directory/docker/pirri/backend/config

	# php files
	cp $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/php81-php.conf  $root_directory/docker/pirri/backend/config
	cp $root_directory/docker/pirri/tmp/pifsc-resource-inventory/docker/config/php.ini  $root_directory/docker/pirri/backend/config


# remove the working directories where the files in the export folder were prepared from
echo "remove all temporary files"
rm -rf $root_directory/docker/pirri/tmp


echo "the docker project files are now ready for configuration and image building/deployment"

read
