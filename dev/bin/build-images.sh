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

set -u
set -e
set -o pipefail

self=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

function exit_with_usage {
  cat << EOF
Usage: build-sandbox-image.sh
Arguments are specified with the following environment variable:
MLSQL_SPARK_VERSION     - the spark version, 2.3/2.4/3.0  default 3.0
SPARK_VERSION           - Spark full version, 2.4.3/3.1.1 default 3.1.1
KOLO_LANG_VERSION       - mlsql version  default 2.2.0-SNAPSHOT
BYZER_NOTEBOOK_VERSION  - byzer notebook version default 0.0.1-SNAPSHOT
MLSQL_TAG               - mlsql git tag to checkout,   no default value
EOF
  exit 1
}

## Builds docker image
function build_images {
    cd "${base_dir}/dev/docker/compose-resource/base/build"
    export COMPOSE_PATH="${base_dir}/dev"
    ## It uses docker-compose.yml to build. option <--no-cache>
#    docker-compose build  --parallel \
    docker-compose build \
     --build-arg SPARK_VERSION=$SPARK_VERSION \
     --build-arg MLSQL_SPARK_VERSION=$MLSQL_SPARK_VERSION \
     --build-arg MLSQL_VERSION=$MLSQL_VERSION \
     --build-arg SPARK_TGZ_NAME=$SPARK_TGZ_NAME \
     --build-arg BYZER_NOTEBOOK_VERSION=$BYZER_NOTEBOOK_VERSION
}

source "${self}/mlsql-functions.sh"

if [[ $@ == *"help"* ]]; then
    exit_with_usage
fi

build_kolo_lang_distribution &&
build_byzer_notebook &&
build_images &&
exit 0