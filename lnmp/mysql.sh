#!/bin/bash
# Version: 1.0.0  
# Author: seven
# Date: 2015/1/5  
# Description: MySql Install Script


if [ -d "/sk/server/mysql" ]; then
    echo 'lnmp has been installed'
    exit 1
fi

export lnmp_dir=$(cd `dirname $0`; pwd)
export mysql_dir=/sk/server/mysql
export mysql_data_dir=/sk/server/data

groupadd mysql
useradd -g mysql -s /sbin/nologin mysql

mkdir -p $mysql_data_dir

tar -xzvf $lnmp_dir/tools/mysql-5.6.14.tar.gz  -C $lnmp_dir/tools | tee /sk/server/log/install/mysql/mysql_tar.log
cd $lnmp_dir/tools/mysql-5.6.14/
cmake -DCMAKE_INSTALL_PREFIX=$mysql_dir/ \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DENABLED_PROFILING=ON \
-DWITH_EXTRA_CHARSETS:STRING=utf8,gbk \
-DWITH_READLINE=1 -DWITH_DEBUG=0 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DMYSQL_DATADIR=$mysql_data_dir \
-DENABLED_LOCAL_INFILE=1 | tee /sk/server/log/install/mysql/mysql_cmake.log
make && make install | tee /sk/server/log/install/mysql/mysql_install.log

chown -R mysql:mysql $mysql_data_dir/
chown -R mysql:mysql $mysql_dir/

\cp -f $mysql_dir/support-files/my-default.cnf  /etc/my.cnf  

\cp -f $mysql_dir/support-files/mysql.server /etc/init.d/mysqld 
sed -i "s#^basedir=$#basedir=$mysql_dir#" /etc/init.d/mysqld
sed -i "s#^datadir=$#datadir=$mysql_data_dir#" /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --level 345 mysqld on

$mysql_dir/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=$mysql_dir --datadir=$mysql_data_dir --user=mysql --tmpdir=/tmp
service mysqld start
$mysql_dir/bin/mysqladmin -u root password 'sk888'
$mysql_dir/bin/mysql -uroot -psk888 <<EOF
drop database test;
delete from mysql.user where user='';
update mysql.user set password=password('sk888') where user='root';
delete from mysql.user where not (user='root') ;
flush privileges;
exit
EOF

echo "###### mysql install completed ######"
sleep 3


clear
echo "------ lnmp install completed ------"