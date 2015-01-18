#!/bin/bash

RABBITMQ_USER=vagrant
RABBITMQ_PASSWORD=vagrant

# add the source for rabbitmq
echo "deb http://www.rabbitmq.com/debian/ testing main" >> "/etc/apt/sources.list"  1> /dev/null 2>&1
wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc  1> /dev/null 2>&1
apt-key add rabbitmq-signing-key-public.asc 1> /dev/null 2>&1

# install rabbitmq
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

# configure RabbitMQ

wget https://raw.githubusercontent.com/joaquimserafim/vagrant-provision-scripts/master/scripts/rabbitmq/rabbitmq.config 1> /dev/null 2>&1

mv rabbitmq.config /etc/rabbitmq 1> /dev/null 2>&1

# ssl
wget https://raw.githubusercontent.com/joaquimserafim/vagrant-provision-scripts/master/scripts/rabbitmq/openssl.cnf 1> /dev/null 2>&1

# SSL
mkdir /etc/rabbitmq/ssl
mkdir testca
cd testca
mkdir certs private
chmod 700 private
echo 01 > serial
touch index.txt

openssl req -x509 -config openssl.cnf -newkey rsa:2048 -days 365 \
    -out cacert.pem -outform PEM -subj /CN=MyTestCA/ -nodes 1> /dev/null 2>&1
openssl x509 -in cacert.pem -out cacert.cer -outform DER 1> /dev/null 2>&1

## server
cd ..
mkdir server
cd server
openssl genrsa -out key.pem 2048 1> /dev/null 2>&1
openssl req -new -key key.pem -out req.pem -outform PEM \
    -subj /CN=$(hostname)/O=server/ -nodes 1> /dev/null 2>&1
cd ../testca
openssl ca -config openssl.cnf -in ../server/req.pem -out \
    ../server/cert.pem -notext -batch -extensions server_ca_extensions 1> /dev/null 2>&1
cd ../server
openssl pkcs12 -export -out keycert.p12 -in cert.pem -inkey key.pem -passout pass:MySecretPassword 1> /dev/null 2>&1

## client
cd ..
mkdir client
cd client
openssl genrsa -out key.pem 2048 1> /dev/null 2>&1
openssl req -new -key key.pem -out req.pem -outform PEM \
    -subj /CN=$(hostname)/O=client/ -nodes 1> /dev/null 2>&1
cd ../testca
openssl ca -config openssl.cnf -in ../client/req.pem -out \
    ../client/cert.pem -notext -batch -extensions client_ca_extensions 1> /dev/null 2>&1
cd ../client
openssl pkcs12 -export -out keycert.p12 -in cert.pem -inkey key.pem -passout pass:MySecretPassword 1> /dev/null 2>&1

#cp /home/vagrant/testca/cacert.pem /etc/rabbitmq/ssl
#cp /home/vagrant/server/cert.pem /etc/rabbitmq/ssl
#cp /home/vagrant/client/key.pem /etc/rabbitmq/ssl


##
service rabbitmq-server restart 1> /dev/null 2>&1
service rabbitmq-server status | grep '{rabbit,"RabbitMQ","[0-9].[0-9].[0-9]"}' | cut -c 8-32 | cut -d',' -f3 | xargs echo "RabbitMQ"
