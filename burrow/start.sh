#!/bin/sh

CONFIG_FILE=/etc/burrow/burrow.toml

sed -i "s~{ZOOKEEPER_SERVERS}~${ZOOKEEPER_SERVERS}~" $CONFIG_FILE
sed -i "s~{ZOOKEEPER_PATH}~${ZOOKEEPER_PATH}~" $CONFIG_FILE
sed -i "s~{KAFKA_BROKERS}~${KAFKA_BROKERS}~" $CONFIG_FILE

echo "start"
cat $CONFIG_FILE

echo "=========start burrow==========="
exec /app/Burrow --config-dir /etc/burrow "${@}"
echo "=========starting burrow========"
