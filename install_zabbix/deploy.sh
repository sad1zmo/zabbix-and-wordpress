#! /bin/bash
set -xe
sudo usermod -aG docker gitlab-runner
sudo chmod 666 /var/run/docker.sock
export MYSQL_USER=${WORDPRESS_DB_USER}
export MYSQL_PASSWORD=${WORDPRESS_DB_PASSWORD}
export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
docker-compose -f /home/gitlab-runner/docker-compose.yaml up -d