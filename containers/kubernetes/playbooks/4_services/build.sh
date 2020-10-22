#!/bin/bash
cd $(dirname $0)
docker build -t mango/httpd:2.4 . && echo 'Success :)' || echo 'Failed :('
