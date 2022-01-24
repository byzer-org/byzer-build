
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
# This Dockerfile should be called from dev directory

FROM python-jdk:3.6-8

## Input arguments
ARG SPARK_VERSION
ARG MLSQL_SPARK_VERSION
ARG MLSQL_VERSION
ARG SPARK_TGZ_NAME
ARG BUILD_PATH
ARG AZURE_BLOB_NAME
ARG SCALA_BINARY_VERSION

## Environment variables
ENV BASE_DIR=/home/deploy

ENV KOLO_LANG_HOME="${BASE_DIR}/kolo-lang" \
    SPARK_HOME="/work/${SPARK_TGZ_NAME}"

ENV SPARK_VERSION="${SPARK_VERSION}" \
    SPARK_TGZ_NAME="${SPARK_TGZ_NAME}" \
    MLSQL_HOME="${BASE_DIR}/kolo-lang" \
    PATH=$PATH:${KOLO_LANG_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin \
    BUILD_PATH=${BUILD_PATH}

## Creates directories
RUN mkdir -p /work/logs /work/user /mlsql/_delta

## README.md and Entrypoint script
COPY ${BUILD_PATH}/start-kolo-lang.sh $BASE_DIR/

## Spark
ADD lib/${SPARK_TGZ_NAME}.tgz /work
COPY ${BUILD_PATH}/log4j.properties ${SPARK_HOME}/conf/

WORKDIR ${BASE_DIR}

## kolo-lang
ADD lib/"mlsql-engine_${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}.tar.gz" ${BASE_DIR}/
RUN mv "mlsql-engine_${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}" kolo-lang
COPY lib/ansj_seg-5.1.6.jar \
  lib/nlp-lang-1.7.8.jar \
  lib/${AZURE_BLOB_NAME} \
  lib/mlsql-assert-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-excel-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-ext-ets-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-shell-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  ${KOLO_LANG_HOME}/libs/
COPY docker/engine/start-local.sh ${KOLO_LANG_HOME}/bin/

ENTRYPOINT $BASE_DIR/start-kolo-lang.sh