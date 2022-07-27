#!/usr/bin/env bash

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

##############################################################################
## Builds a Byzer-lang sandbox docker image; which includes MySQL, Byzer-lang
## and Notebook
##############################################################################

set -u
set -e
set -o pipefail

self=$(cd "$(dirname $0)" && pwd)
source "${self}/mlsql-functions.sh"

function exit_with_usage {
  cat << EOF
Usage: build-sandbox-image.sh
Arguments are specified with the following environment variable:
SPARK_VERSION           - Spark full version, 2.4.3/3.1.1 default 3.1.1
BYZER_LANG_VERSION      - Byzer-lang version  default 2.3.0-SNAPSHOT
BYZER_NOTEBOOK_VERSION  - Byzer-notebook version default 1.0.2-SNAPSHOT
EOF
  exit 1
}

## Builds docker image
function build_image {
    ## Build docker images
    ## Ubuntu 20.04 and MySQL 8
    docker build -t ubuntu-baseimage -f "${base_dir}"/dev/docker/mysql/Dockerfile "${base_dir}"/dev/docker/mysql &&
    ## Adding python 3 conda and Ray
    docker build -t mysql-python:8.0-3.6 -f "${base_image_path}"/Dockerfile "${base_image_path}" &&
    docker build --build-arg SPARK_VERSION=${SPARK_VERSION} \
    --build-arg BYZER_SPARK_VERSION=${BYZER_SPARK_VERSION} \
    --build-arg BYZER_LANG_VERSION=${BYZER_LANG_VERSION} \
    --build-arg SPARK_TGZ_NAME=${SPARK_TGZ_NAME} \
    --build-arg AZURE_BLOB_NAME=${AZURE_BLOB_NAME} \
    --build-arg SCALA_BINARY_VERSION=${SCALA_BINARY_VERSION} \
    -t byzer/byzer-sandbox:${SPARK_VERSION}-${BYZER_LANG_VERSION:-latest} \
    -f "${byzer_sandbox_path}"/Dockerfile \
    "${base_dir}"/dev
}

if [[ $@ == *"help"* ]]; then
    exit_with_usage
fi

function build_notebook {
  SKIP_BUILDING_NOTEBOOK=${SKIP_BUILDING_NOTEBOOK:-false}
  echo "SKIP_BUILDING_NOTEBOOK ${SKIP_BUILDING_NOTEBOOK}"
  if [[ "${SKIP_BUILDING_NOTEBOOK}" == "true" ]]
  then
    echo "Skip building Byzer-notebook"
  else
    build_byzer_notebook
  fi
}
download_byzer_lang_related_jars &&
build_notebook &&
build_image &&
exit 0