#! /bin/sh

root_directory="/c"

cd $root_directory/docker/pridev

docker compose build
docker compose up

read
