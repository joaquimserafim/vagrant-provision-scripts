#!/bin/bash

# zookeeper
apt-get install -y zookeeper 1> /dev/null 2>&1
apt-get install -y zookeeper-bin 1> /dev/null 2>&1
apt-get install -y zookeeperd 1> /dev/null 2>&1
# check zookeeper version
echo srvr | nc localhost 2181 | sed -n 1p

# kafka
SACLA_VERSION="2.9.2"
KAFKA_VERSION="0.8.1.1"
KAFKA_ENV="kafka_$SACLA_VERSION-$KAFKA_VERSION"
KAFKA_URL="http://mirrors.ircam.fr/pub/apache/kafka/0.8.1.1/$KAFKA_ENV.tgz"

rm -rf /home/kafka
mkdir /home/kafka
cd /home/kafka
curl -s -LOk $KAFKA_URL
tar zxf "$KAFKA_ENV.tgz"
cd "$KAFKA_ENV"
bin/kafka-server-start.sh config/server.properties &






#java -cp KafkaOffsetMonitor-assembly-0.2.0.jar \
#     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
#     --zk vagrant-ubuntu-trusty-64 \
#     --port 8080 \
#     --refresh 10.seconds \
#     --retain 2.days