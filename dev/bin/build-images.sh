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
Usage: build-image.sh
Arguments are specified with the following environment variable:
SPARK_VERSION           - Spark full version, 2.4.3/3.1.1 default 3.1.1
BYZER_LANG_VERSION      - Byzer-lang version  default 2.3.0-SNAPSHOT
BYZER_NOTEBOOK_VERSION  - byzer notebook version default 1.0.2-SNAPSHOT
EOF
  exit 1
}

## Builds docker image
function build_images {
    echo "start to build multi image..."
    cd "${base_dir}/dev/docker/compose-resource/base/build"
    export COMPOSE_PATH="${base_dir}/dev"
    ## It uses docker-compose.yml to build. option <--no-cache>
#    docker-compose build  --parallel \
    docker-compose build \
     --build-arg SPARK_VERSION=$SPARK_VERSION \
     --build-arg BYZER_SPARK_VERSION=$BYZER_SPARK_VERSION \
     --build-arg BYZER_LANG_VERSION=$BYZER_LANG_VERSION \
     --build-arg SPARK_TGZ_NAME=$SPARK_TGZ_NAME \
     --build-arg HADOOP_TGZ_NAME=$HADOOP_TGZ_NAME \
     --build-arg BYZER_NOTEBOOK_VERSION=$BYZER_NOTEBOOK_VERSION \
     --build-arg AZURE_BLOB_NAME=${AZURE_BLOB_NAME} \
     --build-arg SCALA_BINARY_VERSION=${SCALA_BINARY_VERSION}
}

source "${self}/mlsql-functions.sh"

if [[ $@ == *"help"* ]]; then
    exit_with_usage
fi

# In the CI process, this special parameter is used to avoid repeated builds.
# If you are not using the build script in CI, you can use the default value regardless of this parameter.
STEP_01_BUILD_SANDBOX_IMAGE=${STEP_01_BUILD_SANDBOX_IMAGE:-false}
STEP_02_BUILD_K8S_IMAGE=${STEP_02_BUILD_K8S_IMAGE:-false}
if [[ $STEP_01_BUILD_SANDBOX_IMAGE == "false" && $STEP_02_BUILD_K8S_IMAGE == "false" ]]; then
    echo "start to download byzer lang..."
  download_byzer_lang_related_jars
fi

if [[ $STEP_01_BUILD_SANDBOX_IMAGE == "false" ]]; then
  echo "start to build byzer notebook..."
  build_byzer_notebook
fi

build_images &&
echo "Build Multi images finished."
exit 0