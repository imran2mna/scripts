#!/bin/bash

# Remove mount options
tune2fs -o ^user_xattr /dev/mapper/home

# Display block details
tune2fs -l /dev/mapper/home | less

# Add mount options
tune2fs -o user_xattr /dev/mapper/home

# Display block details
tune2fs -l /dev/mapper/home | less

