# CI/CD Pipeline для управления инфраструктурой и установкой приложений с помощью GitLab

Эта конфигурация CI/CD автоматизирует процесс развертывания инфраструктуры и установки приложений (WordPress и Zabbix) с использованием GitLab. Пайплайн состоит из следующих этапов:
1. Запуск дочерних пайплайнов для создания инфраструктуры.
2. Установка WordPress.
3. Установка Zabbix.

## Запуск дочерних пайплайнов для создания инфраструктуры.

Эта конфигурация CI/CD автоматизирует процесс развертывания инфраструктуры AWS с использованием Terraform и Ansible. Пайплайн состоит из следующих этапов:
1. Применение конфигурации Terraform для создания ресурсов AWS.
2. Установка Docker и Сompose на созданные сервера с использованием Ansible.
3. Копирование файла Docker Compose на удаленные сервера.
4. Уничтожение созданных ресурсов Terraform. - `запускается руками`


### Настройка AWS с помощью Terraform

Эта конфигурация Terraform настраивает окружение AWS с следующими компонентами:
- Группа безопасности AWS, разрешающая вусь нужный трафик.
- Два экземпляра EC2 с указанным AMI и типом экземпляра.
- Выводит публичные IP-адреса экземпляров EC2 в локальный файл для использования с Ansible.

#### Переменные

- `AWS_ACCESS_KEY`: Ваш AWS access key.
- `AWS_SECRET_KEY`: Ваш AWS secret key.

#### Ресурсы

- **Группа безопасности**: Разрешает SSH (порт 22), HTTP (порт 8000), и дополнительные порты (8080, 9000).
- **Экземпляры EC2**: Создает два экземпляра (`t2.micro`).
- **Локальный файл**: Записывает публичные IP-адреса экземпляров в файл `ansible/hosts`.

#### Выводы

- **wan_ip**: Публичные IP-адреса экземпляров EC2.

### Ansible установка Docker и Compose

- После разворачивания серверов, скрипт `check_ssh.sh` проверяет на протяженнии 5 минут поднялся ли ssh на серверах
- Ansible устанавливает нужные компоненты

### Установка WordPress и Zabbix-Server:

1. Развертывание WordPress на stage окружение - зависит от того есть ли в комите слово stage
2. Развертывание WordPress на prod окружение - зависит от того есть ли в комите слово prod

### Кэширование

Кэширование используется для хранения файла с IP-адресами серверов. (Так же это можно использовать для ускорение сборок - например для maven пакетов или чего нибудь подобного)

```yaml
cache:
  paths:
    - ${CI_PROJECT_DIR}/ansible/hosts
```

- так же используется скрипт `deploy.sh` для установки и запуска Docker Compose в котором безопасно передаются секреты.

### Zabbix-Server

- Устанавливается по той же технологии что для WordPress.
- Все запускается в docker-compose 

### Настройка уведомлений в Telegram
Создайте бота в Telegram и получите API токен.

В Telegram найдите @BotFather, создайте нового бота и сохраните API токен.
Настройка скрипта уведомлений для Zabbix:

Создайте файл zabbix_telegram.sh:

```bash
#!/bin/bash

chat_id="<your_chat_id>"
token="<your_bot_token>"
message=$1

curl -s -X POST "https://api.telegram.org/bot${token}/sendMessage" -d chat_id=${chat_id} -d text="${message}"
```
Скопируйте этот файл на сервер с Zabbix в директорию /usr/lib/zabbix/alertscripts/:

```bash
scp zabbix_telegram.sh root@<IP_Zabbix_Server>:/usr/lib/zabbix/alertscripts/
ssh root@<IP_Zabbix_Server>
chmod +x /usr/lib/zabbix/alertscripts/zabbix_telegram.sh
```

Настройка Zabbix для использования скрипта уведомлений:

- Перейдите в Alerts -> Media types.
- Нажмите Create media type и настройте следующие параметры:
- Name: Telegram
- Type: Script
- Script name: zabbix_telegram.sh
- Script parameters:
- {ALERT.MESSAGE}

Создание триггеров и действий для отправки уведомлений:

В Zabbix frontend, перейдите в Monitoring -> Hosts, найдите ваш WordPress сервер и создайте необходимые триггеры для мониторинга проблем.
Перейдите в Alerts -> Actions, создайте новое действие и настройте его так, чтобы отправлять уведомления в Telegram при срабатывании триггеров.

P.S. На данный момент сборка заканчивается на голой установке Wordpress и Zabbix-Server и является полность автоматизированной.
Я начал делать zabbix agenta и столкнулся с новыми проблемами и мне банально не хватило времени (файлы с настройками я оставил в репозитории).

что бы я делал дальше и что можно было бы изменить:

1) на данный момент все общается по белым айпи, надо перевести в локалку и по хорошему использовать dns
2) вероятнее вместо файла с айпишниками использовал бы прослойку что то типа `nexus`
3) базу данных вынес бы на отдельный сервак и использовал ее
4) в данной конфиграции добавил бы еще 1 агента, так как для ускорения установки Zabbix-Server и Wordpress могут устанавливаться одновременно, но одна из частей ожидает потому что нет свободных агентов
5) Для данной конфигурации выглядит не очень, но в целом можно добавить в Gitlab CI Operate -> Environments для возможности отката деплоя к предыдущим успешным состояниям