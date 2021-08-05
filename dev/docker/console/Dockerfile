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

# The docker build command should be invoked from the dev/docker directory E.g.:
# docker build -t mlsql-console:2.1.0-SNAPSHOT -f console/Dockerfile .
FROM ubuntu:20.04

ARG MLSQL_CONSOLE_VERSION=2.1.0-SNAPSHOT

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN set -ex && \
    apt-get update && \
    apt-get -y install tini vim iputils-ping wget openjdk-14-jdk && \
    rm -rf /var/lib/apt/lists/*

## Setup environment variables
ENV BASE_DIR /home/deploy
ENV MLSQL_CONSOLE_VERSION ${MLSQL_CONSOLE_VERSION}
ENV MLSQL_CONSOLE_HOME ${BASE_DIR}/mlsql-console

## Creates directories
RUN mkdir -p /work/user/
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/libs
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/conf
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/bin

# mlsql-api-console
COPY mlsql-sandbox/lib/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar ${MLSQL_CONSOLE_HOME}/libs/
COPY mlsql-sandbox/conf/application.docker.yml ${MLSQL_CONSOLE_HOME}/conf/application.yml
## Entrypoint script
COPY console/start-console.sh ${MLSQL_CONSOLE_HOME}/bin/

WORKDIR ${MLSQL_CONSOLE_HOME}

ENTRYPOINT ${MLSQL_CONSOLE_HOME}/bin/start-console.sh
