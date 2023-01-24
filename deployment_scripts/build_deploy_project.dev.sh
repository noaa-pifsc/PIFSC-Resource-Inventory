#! /bin/sh

root_directory="/c"

cd $root_directory/odsrptsdev

docker compose build
docker compose up

read
