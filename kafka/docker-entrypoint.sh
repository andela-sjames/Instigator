#!/usr/bin/env bash

set -e

mkdir -p /etc/kafka

if [[ ! -f /etc/kafka/broker-defaults.properties ]]; then
    if [[ "$KAFKA_BROKER_ID" ]]; then
        broker_id=$KAFKA_BROKER_ID
    else
        broker_id=-1
    fi
    echo "broker.id=$broker_id" > /etc/kafka/broker-defaults.properties
fi

# Generate server.properties based on defaults file, which contains the broker id
cat /etc/kafka/broker-defaults.properties > /etc/kafka/server.properties
cat <<- EOF >> /etc/kafka/server.properties
# Essential configuration. There are no sensible defaults for these values, and Kafka will not
# function without them.
listeners=$KAFKA_LISTENERS
zookeeper.connect=$KAFKA_ZOOKEEPER_CONNECT

# Log config. Has defaults, but we generally want to override them on develop and on prod.
default.replication.factor=$KAFKA_DEFAULT_REPLICATION_FACTOR
log.dir=$KAFKA_LOG_DIR
num.partitions=$KAFKA_NUM_PARTITIONS

# Misc. configuration that will likely differ between production and develop, or does not have
# the default we want for either environment.
auto.create.topics.enable=$KAFKA_AUTO_CREATE_TOPICS_ENABLE
auto.leader.rebalance.enable=$KAFKA_AUTO_LEADER_REBALANCE_ENABLE
min.insync.replicas=$KAFKA_MIN_INSYNC_REPLICAS

num.replica.fetchers=$KAFKA_NUM_REPLICA_FETCHERS
EOF

KAFKA_OPTS="$KAFKA_OPTS -javaagent:$KAFKA_HOME_DIR/jmx_prometheus_javaagent-0.12.0.jar=$PROMETHEUS_PORT:$KAFKA_HOME_DIR/kafka-0-8-2.yml"
exec "$KAFKA_HOME_DIR/bin/kafka-server-start.sh" /etc/kafka/server.properties
