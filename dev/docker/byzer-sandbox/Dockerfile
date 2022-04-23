
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
# The Dockerfile for Byzer Sandbox
# Byzer Sandbox has different tags for Spark 3.x and Spark 2.4.x.
# Therefore, Byzer-lang and Spark tar names are arguments

FROM mysql-python:8.0-3.6

## Input arguments
ARG SPARK_VERSION
ARG BYZER_SPARK_VERSION
ARG BYZER_LANG_VERSION
ARG BYZER_NOTEBOOK_VERSION
ARG SPARK_TGZ_NAME
ARG AZURE_BLOB_NAME
ARG SCALA_BINARY_VERSION

## Environment variables
ENV BASE_DIR=/home/deploy \
    BYZER_LANG_HOME="${BASE_DIR}/byzer-lang" \
    SPARK_HOME="/work/${SPARK_TGZ_NAME}" \
    SPARK_VERSION="${SPARK_VERSION}" \
    BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION} \
    BYZER_NOTEBOOK_HOME=${BASE_DIR}/byzer-notebook \
    PATH=$PATH:${BYZER_LANG_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin

## Creates directories
RUN mkdir -p /work/logs /work/user /byzer/_delta

## Spark
ADD lib/${SPARK_TGZ_NAME}.tgz /work
COPY docker/byzer-sandbox/conf/log4j.properties ${SPARK_HOME}/conf/

WORKDIR ${BASE_DIR}

## Byzer-lang
ADD lib/"byzer-lang-${SPARK_VERSION}-${BYZER_LANG_VERSION}.tar.gz" ${BASE_DIR}/
RUN mv "byzer-lang-${SPARK_VERSION}-${BYZER_LANG_VERSION}" byzer-lang && \
    rm ${SPARK_HOME}/jars/velocity-1.5.jar

COPY lib/ansj_seg-5.1.6.jar \
  lib/nlp-lang-1.7.8.jar \
  lib/${AZURE_BLOB_NAME} \
  ${BYZER_LANG_HOME}/libs/
COPY lib/mlsql-assert-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
     lib/mlsql-excel-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
     lib/mlsql-ext-ets-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
     lib/mlsql-shell-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
     lib/mlsql-mllib-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
     ${BYZER_LANG_HOME}/plugin/
COPY docker/byzer-sandbox/conf/byzer.properties ${BYZER_LANG_HOME}/conf/

# byzer-notebook
COPY lib/Byzer-Notebook-${BYZER_NOTEBOOK_VERSION} ${BYZER_NOTEBOOK_HOME}
COPY docker/byzer-notebook/notebook.docker.properties ${BYZER_NOTEBOOK_HOME}/conf/notebook.properties

## Entrypoint script
COPY docker/byzer-sandbox/bin/start-sandbox.sh $BASE_DIR/
ENTRYPOINT $BASE_DIR/start-sandbox.sh