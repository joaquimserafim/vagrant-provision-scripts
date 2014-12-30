#!/bin/bash

# check if zookeeper is installed
echo "checking 'zookeeper'..."
if service zookeeper status | grep -o -E '*[0-9]{3,5}' > /dev/null; then
  echo "'zookeeper' is running"
else
  echo "'zookeeper' is not running/installed, exiting..." >&2
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

if [ ! -d "$KAFKA_ENV" ]; then
  curl -s -LOk $KAFKA_URL
  tar zxf "$KAFKA_ENV.tgz"
  cd "$KAFKA_ENV"
  # change the JVM heap size
  cp bin/kafka-server-start.sh bin/kafka-server-start_old.sh
  sed "s/KAFKA_HEAP_OPTS=\"-Xmx1G -Xms1G\"/KAFKA_HEAP_OPTS=\"-Xmx256M -Xms128M\"/g" bin/kafka-server-start_old.sh > bin/kafka-server-start.sh
  rm -rf bin/kafka-server-start_old.sh
  cd ..
  # donwload slf4j to fix the miss of one jar in kafka :(
  echo "slf4j - fix the miss of one jar by kafka"
  SLF4J_URL="http://www.slf4j.org/dist"
  SLF4J_VERSION="1.7.2"
  curl -s -LOk "$SLF4J_URL/slf4j-$SLF4J_VERSION.tar.gz"
  tar zxf "slf4j-$SLF4J_VERSION.tar.gz"
  cp -f "slf4j-$SLF4J_VERSION/slf4j-nop-$SLF4J_VERSION.jar" "$KAFKA_ENV/libs/"
  rm -rf slf4j-1.7.2*
fi

cd "$KAFKA_ENV"
# start kafka
KAFKA_LOG_DIR="/var/log/kafka"
if [ ! -d "$KAFKA_LOG_DIR" ]; then
  mkdir $KAFKA_LOG_DIR
fi
nohup bin/kafka-server-start.sh config/server.properties > "$KAFKA_LOG_DIR/$(date +%s).log" &

# check kafka is already running
KAFKA_PID=$(ps -eo pid,command | grep kafka | grep -v grep | awk '{print $1}')

while [ -d /proc/$KAFKA_PID ] ; do
  sleep 1
done &&

# testing if kafka is running
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
bin/kafka-topics.sh --list --zookeeper localhost:2181

#java -cp KafkaOffsetMonitor-assembly-0.2.0.jar \
#     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
#     --zk vagrant-ubuntu-trusty-64 \
#     --port 8080 \
#     --refresh 10.seconds \
#     --retain 2.days