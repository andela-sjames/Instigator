#!/usr/bin/env bash

docker-compose build

./scripts/populate_broker.sh

docker-compose up
