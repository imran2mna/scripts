#!/bin/bash

# docker service 
sudo systemctl start docker
systemctl status docker | cat

# environment setup
grep $USER /etc/group | grep docker

