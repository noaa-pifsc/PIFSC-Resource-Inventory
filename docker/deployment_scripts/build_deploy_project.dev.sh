#! /bin/sh

root_directory="/c"

cd $root_directory/docker/odsrptsdev

docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build

read
