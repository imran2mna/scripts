#!/bin/bash

# stop & remove container if exists
docker stop persisent-db && docker rm persisent-db

# remove folder
sudo rm -rfv /opt/mysql-data

# create folder
sudo mkdir -p /opt/mysql-data

# set selinux context - svirt_sandbox_file_t
sudo chcon -R -t svirt_sandbox_file_t /opt/mysql-data

# set to system user ( 27 - mysql ) 
sudo chown -R 27:27 /opt/mysql-data

# run container with following
# - persistent folder map
# - port mapping
# - container variables
docker run --name persisent-db -d -v /opt/mysql-data:/var/lib/mysql -p 3306:3306 -e MYSQL_USER=linux -e MYSQL_PASSWORD=torvalds -e MYSQL_DATABASE=pos -e MYSQL_ROOT_PASSWORD=toor mysql:5.6

# show mapped ports ;)
docker ps
