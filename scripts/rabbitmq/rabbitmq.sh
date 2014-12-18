#!/bin/bash

echo "#install rabbitmq"

RABBITMQ_USER=vagrant
RABBITMQ_PASSWORD=vagrant

# add the source for rabbitmq
echo "add source"

echo "deb http://www.rabbitmq.com/debian/ testing main" >> "/etc/apt/sources.list"  1> /dev/null 2>&1
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc  1> /dev/null 2>&1
apt-key add rabbitmq-signing-key-public.asc  1> /dev/null 2>&1

# install rabbitmq
echo "install"

apt-get install -y rabbitmq-server 1> /dev/null 2>&1
service rabbitmq-server restart 1> /dev/null 2>&1
# add rabbitmq_management plugin
rabbitmq-plugins enable rabbitmq_management 1> /dev/null 2>&1
# add user
rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASSWORD 1> /dev/null 2>&1
rabbitmqctl set_user_tags $RABBITMQ_USER administrator 1> /dev/null 2>&1
rabbitmqctl set_permissions -p / $RABBITMQ_USER ".*" ".*" ".*" 1> /dev/null 2>&1
# delete guest
rabbitmqctl delete_user guest 1> /dev/null 2>&1

service rabbitmq-server restart 1> /dev/null 2>&1
service rabbitmq-server status | grep '{rabbit,"RabbitMQ","[0-9].[0-9].[0-9]"}' | cut -c 8-32 | cut -d',' -f3 | xargs echo "RabbitMQ"

# configure RabbitMQ

