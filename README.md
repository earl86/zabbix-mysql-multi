# zabbix-mysql-multi
zabbix3.x mysql单机多实例 监控脚本及模版 基于percona修改

安装：
1.安装php运行环境


2.安装监控脚本及配置文件

脚本目录:

/etc/zabbix/scripts/ss_get_mysql_stats.php

/etc/zabbix/scripts/get_mysql_stats_wrapper.sh

配置文件目录：

/etc/zabbix/zabbix_agentd.d/userparameter_percona_mysql.conf

3.导入模版文件zbx_export_templates-multi.xml

4.重启zabbix-agent服务
