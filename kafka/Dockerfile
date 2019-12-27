# https://hub.docker.com/_/openjdk
FROM openjdk:14-jdk-alpine

ARG KAFKA_VERSION=2.4.0
ARG KAFKA_HOME_DIR=/opt/kafka
ARG KAFKA_MIRROR=https://www.apache.org/dist/kafka

RUN mkdir -p $KAFKA_HOME_DIR \
 && apk add --no-cache bash gnupg wget \
 && wget -q https://kafka.apache.org/KEYS \
 && wget -q ${KAFKA_MIRROR}/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz \
 && wget -q https://www.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.11-${KAFKA_VERSION}.tgz.asc \
 && gpg --import KEYS \
 && gpg --verify kafka_2.11-${KAFKA_VERSION}.tgz.asc kafka_2.11-${KAFKA_VERSION}.tgz \
 && tar xfz kafka_2.11-${KAFKA_VERSION}.tgz -C $KAFKA_HOME_DIR --strip-components=1 \
 && rm kafka_2.11-${KAFKA_VERSION}.* KEYS

ENV PATH=${PATH}:${KAFKA_HOME_DIR}/bin

ENV KAFKA_VERSION=$KAFKA_VERSION
ENV KAFKA_HOME_DIR=$KAFKA_HOME_DIR

WORKDIR $KAFKA_HOME_DIR
