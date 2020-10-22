#!/bin/bash 

# display images
docker images; echo '' 

# display containers
docker ps -a; echo ''

# create container in background with name
docker run --name automate_container -d ansible/debian:1.2.web 

# interactive to container
echo "Docker hostname is : " $(docker exec -it automate_container hostname)


# list container meta-data
docker inspect -f '{{ .NetworkSettings.IPAddress }}' automate_container

# stop container 
#docker stop automate_container 
docker stop $(docker ps -q)


# restart docker
docker restart automate_container

docker kill -s SIGKILL automate_container

# remove container
docker rm automate_container 
