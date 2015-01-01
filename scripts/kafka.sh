#!/bin/bash

check_zookeekper() {
  echo "checking 'zookeeper'..."
  if service zookeeper status | grep -o -E '*[0-9]{3,5}' > /dev/null; then
    echo "'zookeeper' is running"
  else
    echo "'zookeeper' is not running/installed, exiting..." >&2
    exit 1
  fi
}

# before everything lets check if zookeeper is installed
check_zookeekper

SACLA_VERSION="2.9.2"
KAFKA_VERSION="0.8.1.1"
KAFKA_ENV="kafka_$SACLA_VERSION-$KAFKA_VERSION"
KAFKA_URL="http://mirrors.ircam.fr/pub/apache/kafka/0.8.1.1/$KAFKA_ENV.tgz"
KAFKA_HOME="/home/kafka"
KAFKA_LOG_DIR="/var/log/kafka"

SLF4J_URL="http://www.slf4j.org/dist"
SLF4J_VERSION="1.7.2"

KAFKA_MONITOR_VERSION="0.2.0"
KAFKA_MONITOR_URL="https://github.com/quantifind/\
KafkaOffsetMonitor/releases/download/v$KAFKA_MONITOR_VERSION\
/KafkaOffsetMonitor-assembly-$KAFKA_MONITOR_VERSION.jar"

set_kafka_svc() {
  curl -s https://raw.githubusercontent.com/joaquimserafim/vagrant-provision-scripts/master/scripts/kafka/kafka_svc > \
  /usr/local/bin/kafka_svc
  chmod +x /usr/local/bin/kafka_svc
}

slf4j(){
  echo "slf4j - fix the miss of one jar by kafka"
  curl -s -LOk "$SLF4J_URL/slf4j-$SLF4J_VERSION.tar.gz"
  tar zxf "slf4j-$SLF4J_VERSION.tar.gz"
  cp -f "slf4j-$SLF4J_VERSION/slf4j-nop-$SLF4J_VERSION.jar" "$KAFKA_ENV/libs/"
  rm -rf slf4j-1.7.2*
}

change_jvm_head_size() {
  cp bin/kafka-server-start.sh bin/kafka-server-start_old.sh
  sed "s/KAFKA_HEAP_OPTS=\"-Xmx1G -Xms1G\"/KAFKA_HEAP_OPTS=\"-Xmx256M \
    -Xms128M\"/g" bin/kafka-server-start_old.sh > bin/kafka-server-start.sh
  rm -rf bin/kafka-server-start_old.sh
  cd ..
}

dwl_kafka() {
  curl -s -LOk $KAFKA_URL
  tar zxf "$KAFKA_ENV.tgz"
  cd "$KAFKA_ENV"
}

start_kafka() {
  if [ ! -d "$KAFKA_LOG_DIR" ]; then
    mkdir $KAFKA_LOG_DIR
  fi
  kafka_svc stop
  nohup bin/kafka-server-start.sh config/server.properties > \
  "$KAFKA_LOG_DIR/$(date +%s).log" &
}

test_kafka() {
  KAFKA_PID=""
  while [ -z "$KAFKA_PID" ] && [ -d "/proc/$KAFKA_PID" ]; do
    KAFKA_PID=$(ps -eo pid,command | grep kafka | grep -v grep\
     | awk '{print $1}')
    sleep 1
  done

  echo "a little test with kafka..."
  bin/kafka-topics.sh --create --zookeeper localhost:2181 \
    --replication-factor 1 --partitions 1 --topic test
  KAFKA_RES=$(bin/kafka-topics.sh --list --zookeeper localhost:2181)
  echo "response: $KAFKA_RES"
}

kafka_monitor() {
  cd $KAFKA_HOME
  curl -s -LOk $KAFKA_MONITOR_URL
}

if [ ! -d "$KAFKA_HOME" ]; then
  mkdir $KAFKA_HOME
fi

cd $KAFKA_HOME

if [ ! -d "$KAFKA_ENV" ]; then
  dwl_kafka
  change_jvm_head_size
  slf4j
  set_kafka_svc
fi

cd "$KAFKA_ENV"
start_kafka
test_kafka
kafka_monitor