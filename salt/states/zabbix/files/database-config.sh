#!/bin/bash

mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@{{ ZABBIX_HOST }} identified by '{{ DBPASSWORD }}';
flush privileges;"

cd /usr/share/doc/zabbix-server-mysql-3.0.5/ && zcat create.sql.gz | mysql -uroot zabbix
