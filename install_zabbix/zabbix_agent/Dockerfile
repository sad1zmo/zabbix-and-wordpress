FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y wget gnupg2 dpkg

RUN wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb && \
    sudo dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb  && \
    apt-get update && \
    apt-get install -y zabbix-agent

COPY zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

CMD ["zabbix_agentd", "-f", "-c", "/etc/zabbix/zabbix_agentd.conf"]