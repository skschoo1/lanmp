#!/bin/bash
# Version: 1.0.0  
# Author: seven
# Date: 2015/1/5  
# Description: Php Install Script


if [ -d "/sk/server/php" ]; then
    echo 'lamp has been installed'
    exit 1
fi

lamp_dir=$(cd `dirname $0`; pwd)


#install libpng
    tar -zxvf $lamp_dir/tools/php/libpng-1.2.31.tar.gz -C $lamp_dir/tools/php | tee /sk/server/log/install/php/libpng_tar.log
    cd $lamp_dir/tools/php/libpng-1.2.31/
    ./configure --prefix=/sk/server/libpng | tee /sk/server/log/install/php/libpng_configure.log
    make && make install | tee /sk/server/log/install/php/libpng_install.log


#install jpeg6
    mkdir -p /sk/server/jpeg/bin
    mkdir -p /sk/server/jpeg/lib
    mkdir -p /sk/server/jpeg/include
    mkdir -p /sk/server/jpeg/man/man1

    tar -zxvf $lamp_dir/tools/php/jpegsrc.v6b.tar.gz -C $lamp_dir/tools/php | tee /sk/server/log/install/php/jpeg6_tar.log
    cd $lamp_dir/tools/php/jpeg-6b/
    \cp -f /usr/share/libtool/config/config.sub .
    \cp -f /usr/share/libtool/config/config.guess .
    ./configure --prefix=/sk/server/jpeg \
    --enable-shared \
    --enable-static | tee /sk/server/log/install/php/jpeg6_configure.log
    make && make install | tee /sk/server/log/install/php/jpeg6_install.log


#install freetype
    tar -zxvf $lamp_dir/tools/php/freetype-2.4.6.tar.gz -C $lamp_dir/tools/php | tee /sk/server/log/install/php/freetype_tar.log
    cd $lamp_dir/tools/php/freetype-2.4.6/
    ./configure --prefix=/sk/server/freetype | tee /sk/server/log/install/php/freetype_configure.log
    make && make install | tee /sk/server/log/install/php/freetype_install.log


if [ ! -f "/usr/include/pngconf.h" ]; then
    ln -s /sk/server/libpng/include/pngconf.h /usr/include
fi
if [ ! -f "/usr/include/png.h" ]; then
    ln -s /sk/server/libpng/include/png.h /usr/include
fi


#install gd2
    tar -zxvf $lamp_dir/tools/php/gd-2.0.35.tar.gz -C $lamp_dir/tools/php | tee /sk/server/log/install/php/gd_tar.log
    cd $lamp_dir/tools/php/gd/2.0.35/
    ./configure --prefix=/sk/server/gd2 \
    --with-jpeg=/sk/server/jpeg/ \
    --with-freetype=/sk/server/freetype/ \
    --with-png=/sk/server/libpng/ | tee /sk/server/log/install/php/gd_configure.log
    make && make install | tee /sk/server/log/install/php/gd_install.log


#install php
    tar -zxvf $lamp_dir/tools/php/php-5.3.27.tar.gz -C $lamp_dir/tools/php | tee /sk/server/log/install/php/php_tar.log
    cd $lamp_dir/tools/php/php-5.3.27/
    ./configure --prefix=/sk/server/php \
    --with-config-file-path=/sk/server/php/etc/ \
    --with-apxs2=/sk/server/apache/bin/apxs \
    --with-zlib-dir \
    --with-jpeg-dir=/sk/server/jpeg/ \
    --with-gd=/sk/server/gd2/ \
    --with-png-dir=/sk/server/libpng \
    --with-freetype-dir=/sk/server/freetype/ \
    --enable-mbregex --enable-bcmath \
    --with-libxml-dir=/usr \
    --enable-mbstring=all --with-pdo-mysql \
    --with-mysqli=/sk/server/mysql/bin/mysql_config \
    --with-mysql=/sk/server/mysql/ \
    --enable-soap \
    --enable-sockets \
    --with-openssl \
    --with-curl | tee /sk/server/log/install/php/php_configure.log
    make && make install | tee /sk/server/log/install/php/php_install.log


\cp -f $lamp_dir/tools/php/php-5.3.27/php.ini-production /sk/server/php/etc/php.ini

echo "###### php install completed ######"



