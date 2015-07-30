#!/bin/bash
# Version: 1.0.0  
# Author: seven
# Date: 2015/1/5  
# Description: Init Install Script


if [ -d "/sk/server/nginx" ]; then
    echo 'lnmp has been installed'
    exit 1
fi

sed '/22/a -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT' -i /etc/sysconfig/iptables
sed '/80/a -A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT' -i /etc/sysconfig/iptables
sed '/3306/a -A INPUT -m state --state NEW -m tcp -p tcp --dport 9000 -j ACCEPT' -i /etc/sysconfig/iptables
sed '/9000/a -A INPUT -m state --state NEW -m tcp -p tcp --dport 5180 -j ACCEPT' -i /etc/sysconfig/iptables

mkdir -p /sk/server/log/install/init
mkdir -p /sk/server/log/install/mysql
mkdir -p /sk/server/log/install/nginx
mkdir -p /sk/server/log/install/php

cat /proc/version >> /sk/server/log/install/init/version.log

echo 'init remove server install lanmp tools, waiting....'
yum -y remove httpd php-* mysql-* | tee /sk/server/log/install/init/yum_remove.log

echo 'install gcc g++, compiler.  waiting....'
yum -y install gcc gcc-c++ automake autoconf libtool glibc make cmake | tee /sk/server/log/install/init/yum_compiler.log

echo 'install lnmp rely on repository, waiting....'
yum -y install \
libmcrypt-devel mhash-devel libxslt-devel libjpeg libjpeg-devel \
libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel \
zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel \
ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel \
krb5 krb5-devel libidn libidn-devel openssl openssl-devel | tee /sk/server/log/install/init/yum_rely_on_repository.log
