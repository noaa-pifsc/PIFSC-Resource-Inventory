#! /bin/sh

#development deployment script

echo "running dev deployment script"

root_directory="/c"

mkdir $root_directory/docker/pridev
mkdir $root_directory/docker/pridev/tmp

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone --branch branch_docker_first_try git@picgitlab.nmfs.local:centralized-data-tools/pifsc-resource-inventory.git $root_directory/docker/pridev/tmp/pifsc-resource-inventory

echo "clone the project dependencies"

git clone git@picgitlab.nmfs.local:centralized-data-tools/php-shared-library.git $root_directory/docker/pridev/tmp/php-shared-library

echo "rename configuration files"

#rename the constants.dev.php to constants.php so it can be used as the active configuration file
mv $root_directory/docker/pridev/tmp/parr-tools/ODS/application_code/constants.dev.php $root_directory/docker/pridev/tmp/parr-tools/ODS/application_code/constants.php

#rename the httpd.dev.conf to httpd.conf so it can be used as the active configuration file
mv $root_directory/docker/pridev/tmp/parr-tools/ODS/docker/httpd.dev.conf $root_directory/docker/pridev/tmp/parr-tools/ODS/docker/httpd.conf

#rename the php.dev.ini to php.ini so it can be used as the active PHP configuration file
mv $root_directory/docker/pridev/tmp/parr-tools/ODS/docker/php.dev.ini $root_directory/docker/pridev/tmp/parr-tools/ODS/docker/php.ini




echo "configure apache SSL"

#rename the localhost.crt and localhost.key to cert.crt and cert.key so it can be used as the active SSL files
mv $root_directory/docker/pridev/tmp/pifsc-resource-inventory/docker/localhost.crt $root_directory/docker/pridev/tmp/pifsc-resource-inventory/docker/domain.crt
mv $root_directory/docker/pridev/tmp/pifsc-resource-inventory/docker/localhost.key $root_directory/docker/pridev/tmp/pifsc-resource-inventory/docker/domain.key
mv $root_directory/docker/pridev/tmp/pifsc-resource-inventory/docker/localhost.ssl-passphrase $root_directory/docker/pridev/tmp/pifsc-resource-inventory/docker/ssl-passphrase

echo "configure docker files"
cp $root_directory/docker/pridev/tmp/parr-tools/ODS/docker/docker-compose.prod.dev.yml $root_directory/docker/pridev/tmp/docker-compose.prod.yml
cp $root_directory/docker/pridev/tmp/parr-tools/ODS/docker/docker-compose.dev.yml $root_directory/docker/pridev/tmp/docker-compose.yml
cp $root_directory/docker/pridev/tmp/parr-tools/ODS/docker/Dockerfile.dev $root_directory/docker/pridev/tmp/Dockerfile


# export the docker project files to make the image smaller

echo "create the docker project files structure"
mkdir $root_directory/docker/pridev/pifsc-resource-inventory
mkdir $root_directory/docker/pridev/php-shared-library

echo "copy the docker files"
cp $root_directory/docker/pridev/tmp/Dockerfile $root_directory/docker/pridev/Dockerfile
cp $root_directory/docker/pridev/tmp/docker-compose.yml $root_directory/docker/pridev/docker-compose.yml
cp $root_directory/docker/pridev/tmp/docker-compose.prod.yml $root_directory/docker/pridev/docker-compose.prod.yml

echo "copy the pifsc-resource-inventory directory"
# copy the pifsc-resource-inventory directory
cp -r $root_directory/docker/pridev/tmp/pifsc-resource-inventory/*  $root_directory/docker/pridev/pifsc-resource-inventory

# copy the php-shared-library (.php files only)
echo "copy the php-shared-library directory"
cp -r $root_directory/docker/pridev/tmp/php-shared-library/*  $root_directory/docker/pridev/php-shared-library

# remove the working directories where the files in the export folder were prepared from
echo "remove all temporary files"
rm -rf $root_directory/docker/pridev/tmp


echo "the docker project files are now ready for configuration and image building/deployment"

read
