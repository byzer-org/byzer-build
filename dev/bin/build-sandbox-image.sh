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
MLSQL_SPARK_VERSION     - the spark version, 2.3/2.4/3.0  default 2.4
SPARK_VERSION           - Spark full version, 2.4.3/3.1.1 default 2.4.3
MLSQL_VERSION           - mlsql version  default 2.2.0-SNAPSHOT
MLSQL_CONSOLE_VERSION   - mlsql api console version default 2.2.0-SNAPSHOT
MLSQL_TAG               - mlsql git tag to checkout,   no default value
MLSQL_CONSOLE_TAG       - mlsql-api-console git tag to checkout, no default value
EOF
  exit 1
}


## Builds docker image
function build_image {
    ## Build docker images
    docker build -t mysql-python:8.0-3.6 -f ${base_image_path}/Dockerfile ${base_image_path} &&
    docker build \
    --build-arg MLSQL_SPARK_VERSION=${MLSQL_SPARK_VERSION:-2.4} \
    --build-arg SPARK_VERSION=${SPARK_VERSION:-2.4.3} \
    --build-arg MLSQL_VERSION=${MLSQL_VERSION:-2.2.0-SNAPSHOT} \
    --build-arg MLSQL_CONSOLE_VERSION=${MLSQL_CONSOLE_VERSION:-2.2.0-SNAPSHOT} \
    --build-arg SPARK_TGZ_NAME=${SPARK_TGZ_NAME:-spark-${SPARK_VERSION}-bin-hadoop2.7} \
    -t mlsql-sandbox:${SPARK_VERSION}-${MLSQL_VERSION} \
    -f ${mlsql_sandbox_path}/Dockerfile \
    ${base_dir}/dev
}

self=$(cd "$(dirname $0)" && pwd)
source "${self}/mlsql-functions.sh"

if [[ $@ == *"help"* ]]; then
    exit_with_usage
fi

build_mlsql_distribution &&
build_mlsql_api_console &&
build_image &&
exit 0
