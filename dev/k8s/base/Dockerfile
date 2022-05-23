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

# The Dockerfile for Byzer-lang K8S base image, vendor specific images , aws azure aliyun
# are based on this image. This image includes:
# OpenJDK8
# Spark 3.1.1-bin-hadoop3.2
# Byzer-lang
# Byzer-lang plugins
# Directory structure
# |- /work
# |--- spark
# |--- jdk
# |- /home
# |--- deploy
# |------ byzer-lang
# |-------- plugin
# |-------- libs
# |-------- main
# |-------- bin
# |-------- logs

FROM ubuntu:20.04

ENV SPARK_VERSION=3.1.1 \
    LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    JAVA_HOME=/work/openlogic-openjdk-8u292-b10-linux-x64 \
    BYZER_HOME=/home/deploy/byzer-lang
ENV SPARK_HOME=/work/spark-${SPARK_VERSION}-bin-hadoop3.2
ENV PATH=$PATH:${JAVA_HOME}/bin:${SPARK_HOME}/bin:${BYZER_HOME}/bin

RUN set -ex \
   && apt-get update \
   && apt-get install -y locales tini wget vim curl \
   && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
   && rm -rf /var/lib/apt/lists/* \
   && mkdir -p /work/logs \
   && mkdir -p /work/user \
   && mkdir -p /home/deploy/byzer-lang

ADD "http://download.byzer.org/byzer/misc/jdk/jdk8/openjdk-8u292-b10-linux-x64.tar.gz" /work/
ADD "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz" /work
#
### Byzer-lang comes with higher version of velocity, so delete velocity-1.5.jar
#RUN rm /work/spark-${SPARK_VERSION}-bin-hadoop3.2/jars/velocity-1.5.jar
#COPY docker/byzer-sandbox/conf/log4j.properties ${SPARK_HOME}/conf/
#
#WORKDIR /home/deploy
#
### Byzer-lang. Byzer-lang is downloaded , untarred , renamed in mlsql-functions.sh
#ADD lib/byzer-lang ${WORKDIR}/byzer-lang
#
#COPY lib/ansj_seg-5.1.6.jar lib/nlp-lang-1.7.8.jar lib/juicefs-hadoop-0.17.5-linux-amd64.jar ${BYZER_HOME}/libs/
#
#COPY  lib/mlsql-assert-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
#  lib/mlsql-excel-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
#  lib/mlsql-ext-ets-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
#  lib/mlsql-shell-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
#  lib/mlsql-mllib-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
#  ${MLSQL_HOME}/plugin/
