#! /bin/bash
set -xe
sudo usermod -aG docker gitlab-runner
sudo chmod 666 /var/run/docker.sock
export MYSQL_DATABASE=${WORDPRESS_DB_NAME}
export MYSQL_USER=${WORDPRESS_DB_USER}
export MYSQL_PASSWORD=${WORDPRESS_DB_PASSWORD}
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
export WORDPRESS_DB_USER=${WORDPRESS_DB_USER}
export WORDPRESS_DB_PASSWORD=${WORDPRESS_DB_PASSWORD}
export WORDPRESS_DB_NAME=${WORDPRESS_DB_NAME}
docker-compose -f /home/gitlab-runner/docker-compose.yaml up -d