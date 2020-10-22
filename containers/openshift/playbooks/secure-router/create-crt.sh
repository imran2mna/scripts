#!/bin/bash
cd $(dirname $0)

if [ ! $# -eq 1 ]; then
	echo "Usage: $0 <hostname>" && exit 1
fi

host_name=$1 

openssl genrsa -out ${host_name}.key 2048
openssl req -new -key ${host_name}.key -out ${host_name}.csr -subj "/C=US/ST=NC/L=Linux/O=Linus/OU=LNX/CN=$host_name"
openssl x509 -req -days 366 -in ${host_name}.csr -signkey ${host_name}.key -out ${host_name}.crt
