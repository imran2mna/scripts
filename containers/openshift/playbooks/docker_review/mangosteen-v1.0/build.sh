#!/bin/bash
cd $(dirname $0) 
rm mybin.tar && ls -l && tar -cvf mybin.tar mybin/ 
docker build -t mangosteen/web:v1.0 .
