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

##########################################################################
## Builds a mlsql sandbox docker image; image includes MySQL, mlsql engine
## and mlsql api console.
## The script clones mlsql or mlsql-api-console if either repo does not exists
##########################################################################

set -u
set -e
set -o pipefail

function exit_with_usage {
  cat << EOF
Usage: build-sandbox-image.sh
Arguments are specified with the following environment variable:
MLSQL_SPARK_VERSION     - the spark version, 2.3/2.4/3.0  default 3.0
SPARK_VERSION           - Spark full version, 2.4.3/3.1.1 default 3.1.1
MLSQL_VERSION           - mlsql version  default latest
BYZER_NOTEBOOK_VERSION  - byzer notebook version default latest
MLSQL_TAG               - mlsql git tag to checkout,   no default value
EOF
  exit 1
}


## Builds docker image
function build_image {
    ## Build docker images
    docker build -t ubuntu-baseimage -f "${base_dir}"/dev/docker/mysql/Dockerfile "${base_dir}"/dev/docker/mysql &&
    docker build -t mysql-python:8.0-3.6 -f "${base_image_path}"/Dockerfile ${base_image_path} &&
    docker build --build-arg SPARK_VERSION=${SPARK_VERSION} \
    --build-arg MLSQL_SPARK_VERSION=${MLSQL_SPARK_VERSION} \
    --build-arg MLSQL_VERSION=${MLSQL_VERSION} \
    --build-arg BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION} \
    --build-arg SPARK_TGZ_NAME=${SPARK_TGZ_NAME} \
    --build-arg AZURE_BLOB_NAME=${AZURE_BLOB_NAME} \
    --build-arg SCALA_BINARY_VERSION=${SCALA_BINARY_VERSION} \
    -t byzer/byzer-sandbox:${SPARK_VERSION}-${MLSQL_VERSION:-latest} \
    -f "${mlsql_sandbox_path}"/Dockerfile \
    "${base_dir}"/dev
}

self=$(cd "$(dirname $0)" && pwd)
source "${self}/mlsql-functions.sh"

if [[ $@ == *"help"* ]]; then
    exit_with_usage
fi

build_kolo_lang_distribution &&
build_byzer_notebook &&
build_image &&
exit 0
