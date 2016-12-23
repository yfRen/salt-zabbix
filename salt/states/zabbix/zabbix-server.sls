zabbix-server-install:
  cmd.run:
    - name: rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
    - unless: test -e /etc/yum.repos.d/zabbix.repo
  pkg.installed:
    - names:
      - zabbix-server-mysql
      - zabbix-web-mysql
      - zabbix-get
      - mariadb-server

mariadb-service:
  service.running:
    - name: mariadb.service
    - enable: True
    - require:
      - pkg: zabbix-server-install

zabbix-scripts:
  file.managed:
    - name: /usr/local/src/database-config.sh
    - source: salt://zabbix/files/database-config.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      ZABBIX_HOST: {{ pillar['zabbix']['ZABBIX_HOST'] }}
      DBPASSWORD: {{ pillar['zabbix']['DBPASSWORD'] }}
  cmd.run:
    - name: cd /usr/local/src/ && sh database-config.sh && sleep 2 && touch database-config.sh.lock
    - unless: test -e /usr/local/src/database-config.sh.lock
    - require:
      - service: mariadb-service

zabbix-config:
  file.managed:
    - name: /etc/zabbix/zabbix_server.conf
    - source: salt://zabbix/files/zabbix_server.conf
    - template: jinja
    - defaults:
      DBHOST: {{ pillar['zabbix']['DBHOST'] }}
      DBPASSWORD: {{ pillar['zabbix']['DBPASSWORD'] }}
    - require:
      - cmd: zabbix-scripts

zabbix-service:
  service.running:
    - name: zabbix-server
    - enable: True
    - require:
      - file: zabbix-config

apache-config:
  file.managed:
    - name: /etc/httpd/conf.d/zabbix.conf
    - source: salt://zabbix/files/zabbix.conf
    - require:
      - service: zabbix-service

apache-service:
  service.running:
    - name: httpd
    - enable: True
    - require:
      - file: apache-config
