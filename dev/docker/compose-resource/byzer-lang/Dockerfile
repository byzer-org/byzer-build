
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# The Dockerfile for byzer-lang

FROM byzer/python-jdk:3.6-8

## Input arguments
ARG SPARK_VERSION
## For byzer-extension jar name
ARG BYZER_SPARK_VERSION
ARG BYZER_LANG_VERSION
ARG SPARK_TGZ_NAME
ARG HADOOP_TGZ_NAME
ARG AZURE_BLOB_NAME
ARG SCALA_BINARY_VERSION

## Environment variables
ENV BASE_DIR=/home/deploy \
    SCALA_TGZ_NAME=scala-$SCALA_BINARY_VERSION

ENV BYZER_LANG_HOME="${BASE_DIR}/byzer-lang"

ENV SPARK_HOME="/work/${SPARK_TGZ_NAME}" \
    HADOOP_HOME="/work/${HADOOP_TGZ_NAME:-hadoop-3.2.3}" \
    SCALA_HOME="/work/${SCALA_TGZ_NAME}" \
    MLSQL_HOME="$BYZER_LANG_HOME" \
    MASTER="yarn" \
    DRIVER_MEMORY="2g" \
    SPARK_VERSION="${SPARK_VERSION}" \
    SPARK_TGZ_NAME="${SPARK_TGZ_NAME}" \
    HADOOP_TGZ_NAME="${HADOOP_TGZ_NAME}" \
    PATH=$PATH:${BYZER_LANG_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin \
    BYZER_COMPOSE_PATH=./docker/compose-resource/byzer-lang

## Creates directories
RUN mkdir -p /work/logs /work/user /byzer/_delta

## README.md and Entrypoint script
COPY ${BYZER_COMPOSE_PATH}/start-byzer-lang.sh $BASE_DIR/

## Spark
COPY lib/${SPARK_TGZ_NAME} /work/${SPARK_TGZ_NAME}

ADD lib/${HADOOP_TGZ_NAME}.tar.gz /work

COPY ${BYZER_COMPOSE_PATH}/log4j.properties ${BYZER_COMPOSE_PATH}/spark-env.sh ${SPARK_HOME}/conf/
COPY ${BYZER_COMPOSE_PATH}/hadoop/core-site.xml \
     ${BYZER_COMPOSE_PATH}/hadoop/hdfs-site.xml \
     ${BYZER_COMPOSE_PATH}/hadoop/mapred-site.xml \
     ${BYZER_COMPOSE_PATH}/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/

WORKDIR ${BASE_DIR}

## byzer-lang
COPY lib/byzer-lang ${BASE_DIR}/byzer-lang

COPY lib/ansj_seg-5.1.6.jar \
  lib/nlp-lang-1.7.8.jar \
  lib/${AZURE_BLOB_NAME} \
  lib/mlsql-assert-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-excel-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-ext-ets-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-shell-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-mllib-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  ${BYZER_LANG_HOME}/libs/
COPY ${BYZER_COMPOSE_PATH}/byzer.properties ${BYZER_LANG_HOME}/conf/

ENTRYPOINT $BASE_DIR/start-byzer-lang.sh