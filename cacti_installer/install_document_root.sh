#!/bin/bash


# System Configuration
TIME_ZONE='Asia/Riyadh' 


# Database configuration
DB_ROOT_PASSWD='#3sQ4G9AVbE'
ENABLE_PASS=0


# Cacti Configuration
CACTI_VERSION='1.2.1'
INSTALL_DIR='/opt'
DB_USER='cactiuser'
DB_PASSWORD='cactiuser'
DB_NAME='cacti'
DB_HOST='localhost'
#DB_HOST='%'

# Error codes - Do not edit
ERROR_INSTALL=1
ERROR_SERVICE=2


# Environment details
W_DIR=$(dirname $0)


# Set time zone 
timedatectl set-timezone ${TIME_ZONE}


# Install EPEL rpm channel
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm

# Install MySQL 5.7 server 
yum install  -y mysql-community-server  --disablerepo=mysql80-community --enablerepo=mysql57-community || exit ${ERROR_INSTALL} 
# Install SNMP, RRT tool
yum install -y net-snmp net-snmp-utils net-snmp-libs rrdtool || exit ${ERROR_INSTALL}
# Install HTTP and PHP modules
yum install -y httpd php php-mysql php-snmp php-gd php-ldap php-mbstring php-posix  php-xml php-session php-sockets || exit ${ERROR_INSTALL}

# Start & enable MySQL
systemctl enable mysqld.service && systemctl start mysqld.service || exit ${ERROR_SERVICE}

# Secure database
if [ ! -f /opt/db_root.txt ]; then
 	DB_TMP_PASSWD=$( grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
	mysqladmin --user=root --password="${DB_TMP_PASSWD}" password "${DB_ROOT_PASSWD}" && echo 'Root password is set' > /opt/db_root.txt  || exit ${ERROR_SERVICE}
fi

echo "show databases;" | mysql -uroot -p${DB_ROOT_PASSWD} || exit ${ERROR_SERVICE}
if [ ${ENABLE_PASS} -eq 0 ]; then
	echo "uninstall plugin validate_password;" | mysql -uroot -p${DB_ROOT_PASSWD}
fi

#mysql_secure_installation || exit ${ERROR_SERVICE}
# Performance Tuning for database
cp /etc/my.cnf /etc/my.cnf.orig && chattr +i /etc/my.cnf.orig
cp  ${W_DIR}/my.cnf /etc/my.cnf 
systemctl restart mysqld.service || exit ${ERROR_SERVICE}

# Download & setup Cacti   
#wget https://www.cacti.net/downloads/cacti-${CACTI_VERSION}.tar.gz
tar -xvzf cacti-${CACTI_VERSION}.tar.gz
cp -Rv cacti-${CACTI_VERSION}/* /var/www/html/
chown -Rv apache:apache /var/www/html/*
rm -rfv cacti-${CACTI_VERSION}/

semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/rra(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/log(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/cache(/.*)?"

# Writable during installation only
semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/resource(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/scripts(/.*)?"

restorecon -Rv /var/www/html/ 

# Data for database
mysql -uroot -p${DB_ROOT_PASSWD} mysql < /usr/share/mysql/mysql_test_data_timezone.sql
 
commands="CREATE DATABASE \`${DB_NAME}\`; CREATE USER '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASSWORD}'; GRANT USAGE ON *.* TO '${DB_USER}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASSWORD}';GRANT ALL privileges ON \`${DB_NAME}\`.*
TO '${DB_USER}'@'${DB_HOST}'; GRANT SELECT ON mysql.time_zone_name TO '${DB_USER}'@'${DB_HOST}'; FLUSH PRIVILEGES;"

echo "${commands}" | mysql -uroot -p${DB_ROOT_PASSWD}
mysql -uroot -p${DB_ROOT_PASSWD} ${DB_NAME} < /var/www/html/cacti.sql


# PHP configuration
cp /etc/php.ini /etc/php.ini.orig && chattr +i /etc/php.ini.orig
cp  ${W_DIR}/php.ini /etc/php.ini

systemctl enable httpd --now ||  exit ${ERROR_SERVICE}
systemctl enable snmpd --now ||  exit ${ERROR_SERVICE}

