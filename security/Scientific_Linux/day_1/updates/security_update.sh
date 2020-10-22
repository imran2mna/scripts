#!/bin/bash

# List Security vulnerability fixes count ( security, bugfix, enhancement)
yum updateinfo

# related to above, list security vulnerabilites fixes as list
yum updateinfo list

# Get all security related advisories
yum updateinfo list | grep SLSA

# Get information about advisory
yum updateinfo SLSA-2017:1100-1

# List needed packates to resolve certain CVE vulnerability
yum updateinfo list --cve=CVE-2017-5461

# All package related with security advisory
yum updateinfo list --advisory=SLSA-2017:1100-1

# List kernel related updated advisories
yum updateinfo list kernel

# Count security update packages
yum --security list updates  > /tmp/out.txt; grep needed /tmp/out.txt

# Find critical fixes count
yum updateinfo list | grep -i 'Critical' > /tmp/my.txt; cat /tmp/my.txt | cut -f 1 -d ' ' | sort -u | wc -l

# Apply security updates
yum update --security

# update relevant advisory
yum update --advisory=SLSA-2017:1100-1

# update releavant CVE
yum update --cve=CVE-2017-5461
