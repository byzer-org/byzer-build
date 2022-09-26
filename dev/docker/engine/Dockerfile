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

# The Dockerfile for Byzer-lang K8S image with jdk14

FROM ubuntu:20.04 AS ubuntu-jdk-conda

ARG JDK_MAJOR=14
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    JAVA_HOME=/work/jdk-14 \
    CONDA_HOME=/opt/conda
ENV PATH=$PATH:${JAVA_HOME}/bin:$CONDA_HOME/bin

RUN set -ex \
   && apt-get update \
   && apt-get install -y locales tini wget vim curl \
   && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
   && rm -rf /var/lib/apt/lists/* \
   && mkdir -p /work/logs \
   && mkdir -p /work/user \
   && mkdir -p /home/deploy/byzer-lang

ADD lib/openjdk-14_linux-x64_bin.tar.gz /work/

COPY docker/base/environment.yml ${CONDA_HOME}/

## Install Conda Ray
## Activate Ray 1.8.0 by default
## ray/issues/19938: In ray>=1.8.0 version, python3.6.11 or python3.7.10 should be used.
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_HOME && \
    rm ~/miniconda.sh && \
    ln -s $CONDA_HOME/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    . /etc/profile && \
    conda env create --file ${CONDA_HOME}/environment.yml && \
    conda activate ray-1.12.0 && \
    $CONDA_HOME/bin/conda clean -tipsy -a && \
    echo "conda activate ray-1.12.0" >> /etc/profile && \
    echo "conda activate ray-1.12.0" >> ~/.bashrc && \
    . /etc/profile && \
    ln -fs /bin/bash /bin/sh

FROM ubuntu-jdk-conda AS mlsql-engine

ARG SPARK_VERSION=3.1.1
ARG BYZER_SPARK_VERSION=3.0
ARG BYZER_LANG_VERSION=2.1.0-SNAPSHOT
ARG JUICE_JAR_NAME=juicefs-hadoop-0.17.5-linux-amd64.jar
ARG SCALA_BINARY_VERSION=2.12
ARG AZURE_BLOB_NAME=azure-blob_3.2-1.0-SNAPSHOT.jar

## Setup environment variables
ENV SPARK_HOME /work/spark-${SPARK_VERSION}-bin-hadoop3.2
ENV BASE_DIR /home/deploy
ENV MLSQL_HOME ${BASE_DIR}/byzer-lang
ENV PATH=$PATH:${MLSQL_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin:/opt/conda/bin

## Spark
ADD lib/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz /work
## Byzer-lang comes with higher version of velocity, so delete velocity-1.5.jar
RUN rm /work/spark-${SPARK_VERSION}-bin-hadoop3.2/jars/velocity-1.5.jar
COPY docker/byzer-sandbox/conf/log4j.properties ${SPARK_HOME}/conf/

WORKDIR ${BASE_DIR}

## Byzer-lang. Byzer-lang is downloaded , untarred , renamed in mlsql-functions.sh
ADD lib/byzer-lang ${BASE_DIR}/byzer-lang

##  auxiliary jars
COPY lib/ansj_seg-5.1.6.jar \
  lib/nlp-lang-1.7.8.jar \
  lib/${AZURE_BLOB_NAME} \
  lib/${JUICE_JAR_NAME} \
  ${MLSQL_HOME}/libs/

COPY  lib/mlsql-assert-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-excel-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-ext-ets-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-shell-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-mllib-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  ${MLSQL_HOME}/plugin/

COPY docker/engine/start-local.sh ${MLSQL_HOME}/bin/
COPY docker/engine/entrypoint.sh ${BASE_DIR}/
ENTRYPOINT [ "/home/deploy/entrypoint.sh" ]
