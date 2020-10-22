#!/bin/bash 

NUSER="bulbul"
WORK_DIR=$(dirname $0)

# setting user environment
ls /dev/mapper/home &> /dev/null
if [ $? -gt 0 ]; then
	cryptsetup luksOpen /dev/mapper/vg_data-lv_data home 
fi
mount /dev/mapper/home /home
userdel --remove ${NUSER} 
useradd ${NUSER}
echo ${NUSER} | passwd --stdin ${NUSER}
umount /home

echo  "=== Setting exec mode ==="
mount /dev/mapper/home /home
# copy with preserving attributes 
cp -a /usr/bin/ping /home/${NUSER}
cp  ${WORK_DIR}/user.sh  /home/${NUSER}/user.sh

chown ${NUSER} /home/${NUSER}/user.sh
chgrp ${NUSER} /home/${NUSER}/user.sh
chmod +x /home/${NUSER}/user.sh

mknod -m 666 /home/${NUSER}/${NUSER}random  c 1 9
chown ${NUSER} /home/${NUSER}/${NUSER}random
chgrp ${NUSER} /home/${NUSER}/${NUSER}random

grep '/dev/mapper/home' /etc/mtab
# switch to user
su - ${NUSER}

# nosuid mode
umount /home/
echo "=== Setting nosuid mode ==="
mount -o nosuid /dev/mapper/home /home
grep '/dev/mapper/home' /etc/mtab
su - ${NUSER}

# noexec mode
umount /home/
echo  "=== Setting noexec mode ==="
mount -o noexec /dev/mapper/home /home
grep '/dev/mapper/home' /etc/mtab
su - ${NUSER}

# noexec,nodev mode
umount /home/
echo  "=== Setting noexec,nodev mode ==="
mount -o noexec,nodev /dev/mapper/home /home
grep '/dev/mapper/home' /etc/mtab
su - ${NUSER}

umount /home
lsblk

