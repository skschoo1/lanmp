#!/bin/bash
# Version: 1.0.0  
# Author: seven
# Date: 2015/1/5  
# Description: Php Install Script


if [ -d "/sk/server/nginx" ]; then
    echo 'lnmp has been installed'
    exit 1
fi

export lnmp_dir=$(cd `dirname $0`; pwd)
export libmcrypt_dir=/sk/server/libmcrypt
export php_dir=/sk/server/php

#install libmcrypt
tar -zxvf $lnmp_dir/tools/libmcrypt-2.5.8.tar.gz -C $lnmp_dir/tools | tee /sk/server/log/install/php/libmcrypt_tar.log
cd $lnmp_dir/tools/libmcrypt-2.5.8
./configure --prefix=$libmcrypt_dir | tee /sk/server/log/install/php/libmcrypt_configure.log
make && make install | tee /sk/server/log/install/php/php_install.log

#install php
tar -zxvf $lnmp_dir/tools/php-5.4.21.tar.gz -C $lnmp_dir/tools | tee /sk/server/log/install/php/php_tar.log
cd $lnmp_dir/tools/php-5.4.21
./configure --prefix=$php_dir  --enable-fpm \
--with-mcrypt=$libmcrypt_dir \
--enable-mbstring --disable-pdo --with-curl --disable-debug  --disable-rpath \
--enable-inline-optimization --with-bz2  --with-zlib --enable-sockets \
--enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex \
--with-mhash --enable-zip --with-pcre-regex --with-mysql --with-mysqli \
--with-gd --with-jpeg-dir | tee /sk/server/log/install/php/php_configure.log
make && make install | tee /sk/server/log/install/php/php_install.log

groupadd www
useradd -g www www
cp $php_dir/etc/php-fpm.conf.default $php_dir/etc/php-fpm.conf

sed -i "s/;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/" $php_dir/etc/php-fpm.conf

sed -i "s/user = nobody/user = www/" $php_dir/etc/php-fpm.conf
sed -i "s/group = nobody/group = www/" $php_dir/etc/php-fpm.conf

cp $lnmp_dir/tools/php-5.4.21/php.ini-production $php_dir/lib/php.ini
sed -i "s/;date.timezone =/date.timezone = PRC/" $php_dir/lib/php.ini


