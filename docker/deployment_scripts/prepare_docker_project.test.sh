#! /bin/sh

#test deployment script

echo "running test deployment script"

root_directory="/c"

mkdir $root_directory/docker
mkdir $root_directory/docker/pirrid
mkdir $root_directory/docker/pirrid/tmp

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone git@picgitlab.nmfs.local:centralized-data-tools/pifsc-resource-inventory.git $root_directory/docker/pirrid/tmp/pifsc-resource-inventory

echo "clone the project dependencies"

git clone git@picgitlab.nmfs.local:centralized-data-tools/php-shared-library.git $root_directory/docker/pirrid/tmp/php-shared-library

echo "rename configuration files"

#rename the app_instance_config.test.php to app_instance_config.php so it can be used as the active configuration file
mv $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/RIA/application_code/functions/app_instance_config.test.php $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/RIA/application_code/functions/app_instance_config.php


# remove the dev, prod versions of app_instance_config.php
rm $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/RIA/application_code/functions/app_instance_config.dev.php
rm $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/RIA/application_code/functions/app_instance_config.prod.php


#rename the httpd.test.conf to httpd.conf so it can be used as the active configuration file
mv $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/httpd.test.conf $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/httpd.conf

#rename the php81-php.test.conf to php81-php.conf so it can be used as the active configuration file
mv $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/php81-php.test.conf $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/php81-php.conf

#rename the php.test.ini to php.ini so it can be used as the active PHP configuration file
mv $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/php.test.ini $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/php.ini



echo "configure docker files"
cp $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/docker-compose.prod.test.yml $root_directory/docker/pirrid/tmp/docker-compose.prod.yml
cp $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/docker-compose.test.yml $root_directory/docker/pirrid/tmp/docker-compose.yml
cp $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/Dockerfile.test $root_directory/docker/pirrid/tmp/Dockerfile


# export the docker project files to make the image smaller

echo "create the web folder structure"
mkdir $root_directory/docker/pirrid/www
mkdir $root_directory/docker/pirrid/www/res
mkdir $root_directory/docker/pirrid/www/php-shared-library
mkdir $root_directory/docker/pirrid/www/php-shared-library/css
mkdir $root_directory/docker/pirrid/www/php-shared-library/js
mkdir $root_directory/docker/pirrid/www/php-shared-library/img

echo "create the backend folder structure"
mkdir $root_directory/docker/pirrid/backend
mkdir $root_directory/docker/pirrid/backend/scripts
mkdir $root_directory/docker/pirrid/backend/RIA
mkdir $root_directory/docker/pirrid/backend/RIA/includes
mkdir $root_directory/docker/pirrid/backend/GIM
mkdir $root_directory/docker/pirrid/backend/php-shared-library
mkdir $root_directory/docker/pirrid/backend/config
mkdir $root_directory/docker/pirrid/backend/logs


echo "copy the docker files"
cp $root_directory/docker/pirrid/tmp/Dockerfile $root_directory/docker/pirrid/Dockerfile
cp $root_directory/docker/pirrid/tmp/docker-compose.yml $root_directory/docker/pirrid/docker-compose.yml
cp $root_directory/docker/pirrid/tmp/docker-compose.prod.yml $root_directory/docker/pirrid/docker-compose.prod.yml



echo "copy the pifsc-resource-inventory RIA directory"
# copy the pifsc-resource-inventory RIA directory
cp -r $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/RIA/application_code/*  $root_directory/docker/pirrid/www
# remove the functions folder
rm -rf $root_directory/docker/pirrid/www/functions
# remove the logs folder
rm -rf $root_directory/docker/pirrid/www/logs


# copy the php-shared-library (.php and .inc files only)
echo "copy the php-shared-library backend directory"
cp -r $root_directory/docker/pirrid/tmp/php-shared-library/*.php  $root_directory/docker/pirrid/backend/php-shared-library
cp -r $root_directory/docker/pirrid/tmp/php-shared-library/*.inc  $root_directory/docker/pirrid/backend/php-shared-library
# copy the php-shared library client-side files

echo "copy the php-shared-library client-side directory"
cp -r $root_directory/docker/pirrid/tmp/php-shared-library/css/*  $root_directory/docker/pirrid/www/php-shared-library/css
cp -r $root_directory/docker/pirrid/tmp/php-shared-library/js/*  $root_directory/docker/pirrid/www/php-shared-library/js
cp -r $root_directory/docker/pirrid/tmp/php-shared-library/img/*  $root_directory/docker/pirrid/www/php-shared-library/img



# add in the backend scripts, includes, etc.
cp -r $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/RIA/application_code/functions/*  $root_directory/docker/pirrid/backend/RIA/includes

cp -r $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/GIM/application_code/*  $root_directory/docker/pirrid/backend/GIM

# rename the GIM "functions" folder to "includes"
mv $root_directory/docker/pirrid/backend/GIM/functions  $root_directory/docker/pirrid/backend/GIM/includes





# deploy cron script and crontab definition
cp $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/run_GIM.sh  $root_directory/docker/pirrid/backend/scripts
cp $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/GIM_crontab.txt  $root_directory/docker/pirrid/backend/config

# copy configuration files:

	# copy the apache/php configuration files:
	cp $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/httpd.conf  $root_directory/docker/pirrid/backend/config

	# php files
	cp $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/php81-php.conf  $root_directory/docker/pirrid/backend/config
	cp $root_directory/docker/pirrid/tmp/pifsc-resource-inventory/docker/config/php.ini  $root_directory/docker/pirrid/backend/config


# remove the working directories where the files in the export folder were prepared from
echo "remove all temporary files"
rm -rf $root_directory/docker/pirrid/tmp


echo "the docker project files are now ready for configuration and image building/deployment"

read
