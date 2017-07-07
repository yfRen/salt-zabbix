#!/bin/bash

mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;
grant all privileges on {{ DBNAME }}.* to {{ DBUSER }}@'{{ ZABBIX_HOST }}' identified by '{{ DBPASSWORD }}';
flush privileges;"

sql_path=`find /usr/share/doc -name create.sql.gz`
zcat $sql_path | mysql -uroot zabbix
