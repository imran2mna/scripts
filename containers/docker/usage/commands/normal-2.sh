#!/bin/bash 

# create conatiner with passwed command (sleep 30)
docker run --name automate_container2 -d ansible/debian:1.2.web sleep 30

# stop container
docker kill -s SIGKILL automate_container2
# remove container
docker rm automate_container2

