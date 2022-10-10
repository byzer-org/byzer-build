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
ARG SPARK_VERSION=3.1.1
ARG BYZER_SPARK_VERSION=3.0
ARG SPARK_TGZ_NAME=spark-3.1.1-bin-hadoop3.2
ARG JUICEFS_JAR=juicefs-hadoop-0.17.5-linux-amd64.jar

ENV SPARK_VERSION=${SPARK_VERSION} \
    LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    JAVA_HOME=/work/jdk8 \
    BYZER_HOME=/home/deploy/byzer-lang \
    CONDA_HOME=/work/conda
ENV SPARK_HOME=/work/${SPARK_TGZ_NAME}
ENV PATH=$PATH:${JAVA_HOME}/bin:${SPARK_HOME}/bin:${BYZER_HOME}/bin

## Install Conda and linux commands. Create directories
RUN set -ex \
   && apt-get update \
   && apt-get install -y locales tini wget vim curl \
   && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
   && rm -rf /var/lib/apt/lists/* \
   && mkdir -p /work/logs \
   && mkdir -p /work/user \
   && mkdir -p /work/bin \
   && mkdir -p /home/deploy/byzer-lang \
   && wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh && \
   /bin/bash ~/miniconda.sh -b -p $CONDA_HOME && \
   rm ~/miniconda.sh && \
   ln -s $CONDA_HOME/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
   echo ". $CONDA_HOME/etc/profile.d/conda.sh" >> /etc/profile && \
   echo ". $CONDA_HOME/etc/profile.d/conda.sh" >> ~/.bashrc && \
   . /etc/profile

COPY lib/${SPARK_TGZ_NAME} /work/${SPARK_TGZ_NAME}
COPY k8s/base/fairscheduler.xml /work/${SPARK_TGZ_NAME}/conf/
COPY lib/jdk8 /work/jdk8
COPY docker/byzer-sandbox/conf/log4j.properties ${SPARK_HOME}/conf/

WORKDIR /home/deploy

# Byzer-lang. Byzer-lang is downloaded , untarred , renamed in mlsql-functions.sh
COPY lib/byzer-lang ${BYZER_HOME}

COPY lib/ansj_seg-5.1.6.jar lib/nlp-lang-1.7.8.jar lib/${JUICEFS_JAR} ${BYZER_HOME}/libs/

COPY lib/mlsql-assert-${BYZER_SPARK_VERSION}_2.12-0.1.0-SNAPSHOT.jar \
  lib/mlsql-excel-${BYZER_SPARK_VERSION}_2.12-0.1.0-SNAPSHOT.jar \
  lib/mlsql-ext-ets-${BYZER_SPARK_VERSION}_2.12-0.1.0-SNAPSHOT.jar \
  lib/mlsql-shell-${BYZER_SPARK_VERSION}_2.12-0.1.0-SNAPSHOT.jar \
  lib/mlsql-mllib-${BYZER_SPARK_VERSION}_2.12-0.1.0-SNAPSHOT.jar \
  ${BYZER_HOME}/plugin/

COPY k8s/base/spark-kubernetes_2.12-3.3.0.jar /work/${SPARK_TGZ_NAME}/jars/
COPY k8s/base/entrypoint.sh /work/bin/

ENTRYPOINT [ "/work/bin/entrypoint.sh" ]
