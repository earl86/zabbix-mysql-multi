# zabbix-mysql-multi
zabbix3.x mysql单机多实例 监控脚本及模版 基于percona修改，增加对单主机情况下 多ip单端口，多ip多端口，单ip多端口 不同情况的支持

精简userparameter_percona_mysql.conf配置，取消原版检测key用两位字母代替的方法更直观

安装：
1.安装php运行环境，及zabbix agent

yum install zabbix-agent php php-mysql


2.安装监控脚本及配置文件

脚本目录:

/etc/zabbix/scripts/ss_get_mysql_stats.php

/etc/zabbix/scripts/get_mysql_stats_wrapper.sh

修改以上两个脚本内USER及PASSWORD 配置

配置文件目录：

/etc/zabbix/zabbix_agentd.d/userparameter_percona_mysql.conf

3.导入模版文件zbx_export_templates-multi.xml

模版默认使用Macros {$MYSQL_PORT}=3306，如需要配置其他端口 需要在对应的mysql服务 Host里修改 Inherited and host macros 选项将3306修改为其他端口即可。

4.重启zabbix-agent服务

测试方法：

zabbix_get -s zabbixagentip -p 10050 -k "MySQL[mysqlservieip,mysqlserviceport,mysqld_alive]"

