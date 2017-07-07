#!/bin/bash

sql_path=`find /usr/share/doc -name create.sql.gz`
zcat $sql_path | mysql -h {{ DBHOST }} -P {{ DBPORT }} -u{{ DBUSER }} -p{{ DBPASSWORD }} {{ DBNAME }}
