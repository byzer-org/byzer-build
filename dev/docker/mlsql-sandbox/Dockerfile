
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

FROM mysql-python:8.0-3.6

## Input arguments
ARG SPARK_VERSION
ARG MLSQL_SPARK_VERSION
ARG MLSQL_VERSION
ARG MLSQL_CONSOLE_VERSION
ARG SPARK_TGZ_NAME

## Environment variables
ENV SPARK_VERSION "${SPARK_VERSION}"
ENV SPARK_TGZ_NAME "${SPARK_TGZ_NAME}"
ENV SPARK_HOME "/work/${SPARK_TGZ_NAME}"
ENV BASE_DIR /home/deploy
ENV MLSQL_HOME "${BASE_DIR}/mlsql"
ENV MLSQL_CONSOLE_VERSION ${MLSQL_CONSOLE_VERSION}
ENV MLSQL_CONSOLE_HOME ${BASE_DIR}/mlsql-console
ENV PATH=$PATH:${MLSQL_HOME}/bin:${MLSQL_CONSOLE_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin

## Creates directories
RUN mkdir -p /work/logs
RUN mkdir -p /work/user
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/libs
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/conf
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/bin

## README.md
COPY docker/mlsql-sandbox/README.md ${BASE_DIR}/

## Spark
ADD lib/${SPARK_TGZ_NAME}.tgz /work
COPY docker/mlsql-sandbox/conf/log4j.properties ${SPARK_HOME}/conf/

WORKDIR ${BASE_DIR}

## mlsql
ADD lib/"mlsql-engine_${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}.tar.gz" ${BASE_DIR}/
RUN mv "mlsql-engine_${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}" mlsql
COPY lib/ansj_seg-5.1.6.jar ${MLSQL_HOME}/libs/
COPY lib/nlp-lang-1.7.8.jar ${MLSQL_HOME}/libs/

# mlsql-api-console
COPY lib/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar ${MLSQL_CONSOLE_HOME}/libs/
COPY docker/mlsql-sandbox/conf/application.docker.yml ${MLSQL_CONSOLE_HOME}/conf/
## Db init script
COPY docker/mlsql-sandbox/bin/db_init.sh $BASE_DIR/


## Entrypoint script
COPY docker/mlsql-sandbox/bin/start-sandbox.sh $BASE_DIR/

ENTRYPOINT $BASE_DIR/start-sandbox.sh
