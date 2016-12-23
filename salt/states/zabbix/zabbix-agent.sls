zabbix-agent-install:
  cmd.run:
    - name: rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
    - unless: test -e /etc/yum.repos.d/zabbix.repo
  pkg.installed:
    - names:
      - zabbix-agent
      - sysstat

agent-config:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://zabbix/files/zabbix_agentd.conf
    - template: jinja
    - defaults:
      ZABBIX_SERVER_HOST: {{ pillar['zabbix']['ZABBIX_SERVER_HOST'] }}
      SERVERACTIVE: {{ pillar['zabbix']['SERVERACTIVE'] }}
      LOCAL_IP: {{ grains['ipv4'][0] }}

zabbix-scripts:
  file.recurse:
    - name: /var/zabbix
    - source: salt://zabbix/files/zabbix
    - user: root
    - group: root
    - file_mode: 755
    - require:
      - file: agent-config

agent-service:
  service.running:
    - name: zabbix-agent
    - enable: True
    - require:
      - file: zabbix-scripts
