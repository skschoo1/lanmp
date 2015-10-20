# lanmp
sk lanmp 一键安装包



# LAMP 说明

多站点配置：
复制： /sk/server/apache/conf.d/【唯一标识】-vhosts.conf   <br />
配置：【唯一标识】-vhosts.conf         <br />
生效：service httpd restart   <br />
sklamp结构
     mysql目录： /sk/server/mysql（默认密码：sk888）
     mysql data目录： /sk/server/data
       php目录： /sk/server/php
    apache目录： /sk/server/apache
命令一览：
 mysql命令： service mysql (start|stop|restart|reload|status)
apache命令： service httpd (start|stop|restart|reload|status)
网站根目录：
默认web根目录： /sk/wwwroot
