#!/bin/bash 

# physical volume
pvcreate /dev/sdb1

# volume group
vgcreate vg_data /dev/sdb1

# logical volume 
lvcreate -n lv_data --size +1000M vg_data

# luks format
cryptsetup luksFormat /dev/mapper/vg_data-lv_data

# luks open fd
cryptsetup luksOpen /dev/mapper/vg_data-lv_data home

# display block devices
lsblk

# ext4 filesystem
mkfs.ext4 /dev/mapper/home

