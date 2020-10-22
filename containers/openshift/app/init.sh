#!/bin/bash
oc new-app --name=hello --docker-image=docker.io/httpd --insecure-registry

