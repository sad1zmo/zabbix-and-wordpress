#! /bin/bash
set -xe
export WORDPRESS_DB_HOST=${WORDPRESS_DB_HOST}
export WORDPRESS_DB_PASSWORD=${WORDPRESS_DB_PASSWORD}
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
export WORDPRESS_DB_NAME=${WORDPRESS_DB_NAME}
sudo docker-compose -f ~/docker-compose.yaml up -d