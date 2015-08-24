#!/usr/bin/env bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80\
  --recv 7F0CEB10 1> /dev/null 2>&1

echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart\
 dist 10gen" | sudo tee /etc/apt/sources.list.d/mongodb.list 1> /dev/null 2>&1

apt-get update 1> /dev/null 2>&1
apt-get install -y mongodb-org 1> /dev/null 2>&1

# donwload mongodb.conf
#curl -s -o /etc/mongod.conf https://raw.githubusercontent\
#.com/joaquimserafim/vagrant-provision-scripts/master/scripts\
#/mongodb/mongod.conf

#service mongod stop
#service mongod start
mongod --version | sed -n 1p
