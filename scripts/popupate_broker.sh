#!/usr/bin/env bash

# Setup local topics

set -e

echo "Cleaning up previous install...."
docker-compose rm -fsv

echo "Starting up broker...."

docker-compose up -d broker

echo "Waiting 30 seconds for exhibitor and broker to stabilize...."
sleep 30

docker exec instigator_broker_1 kafka-topics.sh \
  --create \
  --zookeeper zoo1:2181 \
  --topic sampleOne \
  --replication-factor 3 \
  --partitions 1 \
  --config min.insync.replicas=2 \
  --config cleanup.policy=compact

docker exec instigator_broker_1 kafka-topics.sh \
  --create \
  --zookeeper zoo1:2181 \
  --topic sampleTwo \
  --replication-factor 3 \
  --partitions 1 \
  --config min.insync.replicas=2 \
  --config cleanup.policy=compact

docker exec instigator_broker_1 kafka-topics.sh \
  --create \
  --zookeeper zoo1:2181 \
  --topic sampleThree \
  --replication-factor 3 \
  --partitions 1 \
  --config min.insync.replicas=2 \
  --config cleanup.policy=compact

docker exec instigator_broker_1 kafka-topics.sh \
  --create \
  --zookeeper zoo1:2181 \
  --topic sampleFour \
  --replication-factor 3 \
  --partitions 1 \
  --config min.insync.replicas=2 \
  --config cleanup.policy=compact

echo "Allowing broker to stabilize before shutting down...."

sleep 30

docker-compose stop

echo "Fin."
