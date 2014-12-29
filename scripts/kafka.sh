#!/bin/bash

# check if zookeeper is installed

if service zookeeper status | grep -o -E '*[0-9]{3,5}' > /dev/null; then
  echo "'zookeeper' is running"
else
  echo "'zookeeper' is not running, exiting..."
  exit 1
fi

SACLA_VERSION="2.9.2"
KAFKA_VERSION="0.8.1.1"
KAFKA_ENV="kafka_$SACLA_VERSION-$KAFKA_VERSION"
KAFKA_URL="http://mirrors.ircam.fr/pub/apache/kafka/0.8.1.1/$KAFKA_ENV.tgz"
KAFKA_DIR="/home/kafka"

if [ ! -d "$KAFKA_DIR" ]; then
  mkdir $KAFKA_DIR
fi

cd /home/kafka

if [ ! -f "$KAFKA_ENV" ]; then
  curl -s -LOk $KAFKA_URL
  tar zxf "$KAFKA_ENV.tgz"
fi

cd "$KAFKA_ENV"
#bin/kafka-server-start.sh config/server.properties &





#java -cp KafkaOffsetMonitor-assembly-0.2.0.jar \
#     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
#     --zk vagrant-ubuntu-trusty-64 \
#     --port 8080 \
#     --refresh 10.seconds \
#     --retain 2.days