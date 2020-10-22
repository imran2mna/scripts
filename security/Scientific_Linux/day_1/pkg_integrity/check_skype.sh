#!/bin/bash

GPG_KEY="skype-gpgkey"
PACKAGE="skype-64.rpm"

#wget https://repo.skype.com/latest/skypeforlinux-64.rpm
wget -O ${PACKAGE} http://127.0.0.1/skypeforlinux-64.rpm
wget -O ${GPG_KEY} $(rpm -qp --scripts ${PACKAGE} | grep gpgkey | cut -f 2 -d '=')

# include gpg-key
rpm --import ${GPG_KEY}
rpm -K ${PACKAGE}; echo "==========================" 
rpm -vK ${PACKAGE}

KEY_ID=$(rpm -vK skype-64.rpm | grep '    V4 RSA/SHA1 Signature, key ID ' | cut -f 2 -d ',' | cut -f 1 -d ':' | cut -f 4 -d ' ')

# list available key
rpm -qa gpg-pubkey

RPM_KEY=$(rpm -qa gpg-pubkey | grep ${KEY_ID})
sleep 1 && rpm -qi ${RPM_KEY}

rpm -e ${RPM_KEY}

