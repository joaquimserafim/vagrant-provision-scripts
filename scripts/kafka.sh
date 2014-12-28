#!/bin/bash

# zookeeper
apt-get install -y zookeeper 1> /dev/null 2>&1
apt-get install -y zookeeper-bin 1> /dev/null 2>&1
apt-get install -y zookeeperd 1> /dev/null 2>&1

# kafka

KAFKA_VERSION="0.8.1.1"
KAFKA_URL="http://mirrors.ircam.fr/pub/apache/kafka/0.8.1.1/kafka_2.9.2-$KAFKA_VERSION.tgz"

rm -rf /home/kafka
mkdir /home/kafka
cd /home/kafka
curl -s $KAFKA_URL




#java -cp KafkaOffsetMonitor-assembly-0.2.0.jar \
#     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
#     --zk vagrant-ubuntu-trusty-64 \
#     --port 8080 \
#     --refresh 10.seconds \
#     --retain 2.days