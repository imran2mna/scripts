#!/bin/bash

# Check parition status
cryptsetup status home

# luks close
cryptsetup luksClose home


# Remove partion created from LUKS partion :| 
cryptsetup remove /dev/mapper/home

# Erase luks, remove key
cryptsetup luksRemoveKey /dev/vg_data/lv_data
blkid

# lvremove disk
lvremove /dev/vg_data/lv_data 

# vgremove 
vgremove vg_data

# pvremove 
pvremove /dev/sdb1

# list block devices
lsblk

