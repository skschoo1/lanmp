# lanmp
sk lanmp 一键安装包



# LAMP 说明

多站点配置：
复制： /sk/server/apache/conf.d/【唯一标识】-vhosts.conf   <br />
配置：【唯一标识】-vhosts.conf         <br />
生效：service httpd restart   <br />
sklamp结构   <br />
     mysql目录： /sk/server/mysql（默认密码：sk888）   <br />
     mysql data目录： /sk/server/data   <br />
       php目录： /sk/server/php   <br />
    apache目录： /sk/server/apache   <br />
命令一览：   <br />
 mysql命令： service mysql (start|stop|restart|reload|status)   <br />
apache命令： service httpd (start|stop|restart|reload|status)   <br />
网站根目录：   <br />
默认web根目录： /sk/wwwroot   <br />
