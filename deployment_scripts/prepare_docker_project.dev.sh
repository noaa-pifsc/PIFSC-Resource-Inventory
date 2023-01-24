#! /bin/sh

#development deployment script

echo "running dev deployment script"

root_directory="/c"

mkdir $root_directory/pridev
mkdir $root_directory/pridev/tmp

echo "clone the project repository"

#checkout the git projects into the same temporary docker directory
git clone --branch branch_docker_first_try git@picgitlab.nmfs.local:centralized-data-tools/pifsc-resource-inventory.git $root_directory/pridev/tmp/pifsc-resource-inventory

echo "clone the project dependencies"

git clone git@picgitlab.nmfs.local:centralized-data-tools/php-shared-library.git $root_directory/pridev/tmp/php-shared-library

echo "rename configuration files"

#rename the constants.dev.php to constants.php so it can be used as the active configuration file
mv $root_directory/pridev/tmp/pifsc-resource-inventory/RIA/application_code/constants.dev.php $root_directory/pridev/tmp/pifsc-resource-inventory/RIA/application_code/constants.php
mv $root_directory/pridev/tmp/pifsc-resource-inventory/GIM/application_code/constants.dev.php $root_directory/pridev/tmp/pifsc-resource-inventory/GIM/application_code/constants.php


#rename the httpd.dev.conf to httpd.conf so it can be used as the active configuration file
mv $root_directory/pridev/tmp/pifsc-resource-inventory/docker/httpd.dev.conf $root_directory/pridev/tmp/pifsc-resource-inventory/docker/httpd.conf

echo "configure apache SSL"

#rename the localhost.crt and localhost.key to cert.crt and cert.key so it can be used as the active SSL files
mv $root_directory/pridev/tmp/pifsc-resource-inventory/docker/localhost.crt $root_directory/pridev/tmp/pifsc-resource-inventory/docker/domain.crt
mv $root_directory/pridev/tmp/pifsc-resource-inventory/docker/localhost.key $root_directory/pridev/tmp/pifsc-resource-inventory/docker/domain.key
mv $root_directory/pridev/tmp/pifsc-resource-inventory/docker/localhost.ssl-passphrase $root_directory/pridev/tmp/pifsc-resource-inventory/docker/ssl-passphrase

echo "configure docker files"

cp $root_directory/pridev/tmp/pifsc-resource-inventory/docker/docker-compose.dev.yml $root_directory/pridev/tmp/docker-compose.yml
cp $root_directory/pridev/tmp/pifsc-resource-inventory/docker/Dockerfile $root_directory/pridev/tmp/Dockerfile


# export the docker project files to make the image smaller

echo "create the docker project files structure"
mkdir $root_directory/pridev/pifsc-resource-inventory
mkdir $root_directory/pridev/php-shared-library

echo "copy the docker files"
cp $root_directory/pridev/tmp/Dockerfile $root_directory/pridev/Dockerfile
cp $root_directory/pridev/tmp/docker-compose.yml $root_directory/pridev/docker-compose.yml

echo "copy the pifsc-resource-inventory directory"
# copy the pifsc-resource-inventory directory
cp -r $root_directory/pridev/tmp/pifsc-resource-inventory/*  $root_directory/pridev/pifsc-resource-inventory

# copy the php-shared-library (.php files only)
echo "copy the php-shared-library directory"
cp -r $root_directory/pridev/tmp/php-shared-library/*  $root_directory/pridev/php-shared-library

# remove the working directories where the files in the export folder were prepared from
echo "remove all temporary files"
rm -rf $root_directory/pridev/tmp


echo "the docker project files are now ready for configuration and image building/deployment"

read
