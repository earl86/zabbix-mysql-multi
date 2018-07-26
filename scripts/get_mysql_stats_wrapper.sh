#!/bin/sh
# The wrapper for Cacti PHP script.
# It runs the script every 5 min. and parses the cache file on each following run.
# Version: 1.1.5
#
# This program is part of Percona Monitoring Plugins
# License: GPL License (see COPYING)
# Copyright: 2015 Percona
# Authors: Roman Vynar

HOST=$1
PORT=$2
ITEM=$3
USER=zabbix
PASSWORD=zabbix2018
DIR=`dirname $0`
CMD="/usr/bin/php -q $DIR/ss_get_mysql_stats.php --host $HOST --items $ITEM --port $PORT"
CACHEFILE="/tmp/$HOST-$PORT-mysql_cacti_stats.txt"

if [ "$ITEM" = "running_slave" ]; then
    # Check for running slave
    RES=`HOME=~zabbix mysql -h $HOST -P $PORT -u$USER -p$PASSWORD -e 'SHOW SLAVE STATUS\G' | egrep '(Slave_IO_Running|Slave_SQL_Running):' | awk -F: '{print $2}' | tr '\n' ','`
    if [ "$RES" = " Yes, Yes," ]; then
        echo 1
    else
        echo 0
    fi
    exit
elif [ "$ITEM" = "mysqld_alive" ]; then
    RES=`HOME=~zabbix mysql -h $HOST -P $PORT -u$USER -p$PASSWORD -N -e 'select 1 from dual;'`
    if [ "$RES" = "1" ]; then
        echo 1
    else
        echo 0
    fi
    exit
elif [ -e $CACHEFILE ]; then
    # Check and run the script
    #TIMEFLM=`stat -c %Y /tmp/$HOST-$PORT-mysql_cacti_stats.txt`
	  TIMEFLM=`stat -c %Y $CACHEFILE`
    TIMENOW=`date +%s`
    if [ `expr $TIMENOW - $TIMEFLM` -gt 300 ]; then
        rm -f $CACHEFILE
        $CMD 2>&1 > /dev/null
    fi
else
    $CMD 2>&1 > /dev/null
fi

# Parse cache file
if [ -e $CACHEFILE ]; then
    cat $CACHEFILE | grep $ITEM | awk -F: '{print $2}'
else
    echo "ERROR: run the command manually to investigate the problem: $CMD"
fi

