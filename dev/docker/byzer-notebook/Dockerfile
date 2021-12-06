
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

FROM ubuntu:focal-20210827

## Input arguments
ARG BYZER_NOTEBOOK_VERSION

## Environment variables
ENV BASE_DIR=/home/deploy
ENV BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION} \
    BYZER_NOTEBOOK_HOME=${BASE_DIR}/byzer-notebook

WORKDIR ${BASE_DIR}

# byzer-notebook
COPY lib/Byzer-Notebook-${BYZER_NOTEBOOK_VERSION} ${BYZER_NOTEBOOK_HOME}

ENTRYPOINT "$BYZER_NOTEBOOK_HOME"/startup.sh hangup