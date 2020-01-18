#!/usr/bin/env bash

docker-compose build && ./scripts/populate_broker.sh

JMX_PORT=9999 docker-compose up
