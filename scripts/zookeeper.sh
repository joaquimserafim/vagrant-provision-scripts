#!/bin/bash

sudo apt-get update  1> /dev/null 2>&1
sudo apt-get install -y zookeeper 1> /dev/null 2>&1
sudo apt-get install -y zookeeper-bin 1> /dev/null 2>&1
sudo apt-get install -y zookeeperd 1> /dev/null 2>&1
# check zookeeper version
echo srvr | nc localhost 2181 | sed -n 1p
