FROM wordpress:latest

RUN apt-get update && \
    apt-get install -y zabbix-agent && \
    apt-get clean

COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

CMD ["sh", "-c", "/usr/sbin/zabbix_agentd && docker-entrypoint.sh"]