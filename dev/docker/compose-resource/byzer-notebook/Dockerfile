
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

FROM byzer/python-jdk:3.6-8

## Environment variables
ENV BASE_DIR=/home/deploy
ENV BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION} \
    BYZER_NOTEBOOK_HOME=${BASE_DIR}/byzer-notebook \
    NOTEBOOK_COMPOSE_PATH=./docker/compose-resource/byzer-notebook


WORKDIR ${BASE_DIR}

# byzer-notebook
COPY ./lib/byzer-notebook ${BYZER_NOTEBOOK_HOME}
COPY ${NOTEBOOK_COMPOSE_PATH}/notebook.docker.properties ${BYZER_NOTEBOOK_HOME}/conf/notebook.properties
COPY ${NOTEBOOK_COMPOSE_PATH}/entrypoint.sh ${BYZER_NOTEBOOK_HOME}/

ENTRYPOINT ${BYZER_NOTEBOOK_HOME}/entrypoint.sh