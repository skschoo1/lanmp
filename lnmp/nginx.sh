#!/bin/bash
# Version: 1.0.0  
# Author: seven
# Date: 2015/1/5  
# Description: Nginx Install Script
#open nginx  $nginx_dir/sbin/nginx -s reload
#open php-fpm 


if [ -d "/sk/server/nginx" ]; then
    echo 'lnmp has been installed'
    exit 1
fi

export lnmp_dir=$(cd `dirname $0`; pwd)
export pcre_dir=/sk/server/pcre
export zlib_dir=/sk/server/zlib
export openssl_dir=/sk/server/openssl
export php_dir=/sk/server/php
export nginx_dir=/sk/server/nginx

tar -zxvf $lnmp_dir/tools/pcre-8.32.tar.gz -C $lnmp_dir/tools
mv $lnmp_dir/tools/pcre-8.32 $pcre_dir
cd $pcre_dir
./configure
make && make install


tar -zxvf $lnmp_dir/tools/zlib-1.2.8.tar.gz -C $lnmp_dir/tools
mv $lnmp_dir/tools/zlib-1.2.8 $zlib_dir
cd $zlib_dir
./configure 
make && make install


tar -zxvf $lnmp_dir/tools/openssl-1.0.1e.tar.gz -C $lnmp_dir/tools
mv $lnmp_dir/tools/openssl-1.0.1e $openssl_dir


tar -zxvf $lnmp_dir/tools/nginx-1.4.3.tar.gz -C $lnmp_dir/tools
cd $lnmp_dir/tools/nginx-1.4.3
./configure --prefix=$nginx_dir \
--with-http_ssl_module \
--with-pcre=$pcre_dir \
--with-zlib=$zlib_dir \
--with-openssl=$openssl_dir
make && make install

sed -i "s/#user  nobody;/user  www;/" $nginx_dir/conf/nginx.conf
sed -i "s/server_name  localhost;/server_name  _;/" $nginx_dir/conf/nginx.conf
sed -i "s/root   html;/root   \/sk\/wwwroot;/" $nginx_dir/conf/nginx.conf
sed "/# HTTPS server/i include $nginx_dir\/vhosts_conf\/*.conf;" -i $nginx_dir/conf/nginx.conf

#gzip
sed -i "s/#gzip  on;/gzip  on;/" $nginx_dir/conf/nginx.conf
sed -i '/gzip  on;/a gzip_min_length  5k;' $nginx_dir/conf/nginx.conf 
sed -i '/gzip_min_length  5k;/a gzip_buffers     4 16k;' $nginx_dir/conf/nginx.conf 
sed -i '/gzip_buffers     4 16k;/a gzip_http_version 1.0;' $nginx_dir/conf/nginx.conf 
sed -i '/gzip_http_version 1.0;/a gzip_comp_level 3;' $nginx_dir/conf/nginx.conf 
sed -i '/gzip_comp_level 3;/a gzip_types       text\/plain application\/x-javascript text\/css application\/xml text\/javascript application\/x-httpd-php image\/jpeg image\/gif image\/png;' $nginx_dir/conf/nginx.conf 
sed -i '/gzip_types       text\/plain application\/x-javascript text\/css application\/xml text\/javascript application\/x-httpd-php image\/jpeg image\/gif image\/png;/a gzip_vary on;' $nginx_dir/conf/nginx.conf 
sed -i '/gzip_vary on;/a gzip_disable "MSIE [1-6]\.";' $nginx_dir/conf/nginx.conf 

mkdir -p $nginx_dir/vhosts_conf
\cp -f $lnmp_dir/tools/vhosts_modoupi_sk.conf $nginx_dir/vhosts_conf/
mkdir -p /sk/wwwroot/sk
chmod +w /sk/wwwroot
chown www:www /sk/wwwroot -R
touch /sk/wwwroot/sk/index.php
echo "<?php phpinfo();" >> /sk/wwwroot/sk/index.php

$nginx_dir/sbin/nginx
$php_dir/sbin/php-fpm


\cp -f $lnmp_dir/tools/nginx /etc/init.d/nginx
chmod a+x /etc/init.d/nginx
chkconfig --add nginx
chkconfig --level 345 nginx on

\cp -f $lnmp_dir/tools/php-fpm /etc/init.d/php-fpm
chmod a+x /etc/init.d/php-fpm
chkconfig --add php-fpm
chkconfig --level 345 php-fpm on

/etc/init.d/iptables restart


 