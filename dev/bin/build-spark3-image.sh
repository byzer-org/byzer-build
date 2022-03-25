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
## Builds a mlsql-spark3 K8S image;
##############################################################################
set -u
set -e
set -o pipefail

export JUICEFS_VERSION=${JUICEFS_VERSION:-0.15.2}
juice_jar_name="juicefs-hadoop-${JUICEFS_VERSION}-linux-amd64.jar"

function build_image {
    local spark_version=3.1.1

    if [[ ! -f "${lib_path}/openjdk-14_linux-x64_bin.tar.gz" ]]
    then
      (
      echo "Downloading openjdk-14" &&
      cd ${lib_path} &&
      curl -O https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz
      ) || exit 1
    fi

    if [[ ! -f "${lib_path}/${juice_jar_name}" ]]
    then
      (
      echo "Downloading juicefs-${JUICEFS_VERSION}" &&
      cd ${lib_path} &&
      curl -O "https://github.com/juicedata/juicefs/releases/download/v${JUICEFS_VERSION}/${juice_jar_name}"
      ) || exit 1
    fi

    if [[ ! -f ${lib_path}/miniconda.sh ]]
    then
      echo "Downloading conda-4.5.11" &&
      wget https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ${lib_path}/miniconda.sh || exit 1
    fi

    docker build -t byzer/byzer-lang-k8s:3.1.1-${BYZER_LANG_VERSION:-latest} \
    --build-arg SPARK_VERSION=${spark_version} \
    --build-arg MLSQL_SPARK_VERSION=3.0 \
    --build-arg BYZER_LANG_VERSION=${BYZER_LANG_VERSION:-latest} \
    --build-arg JUICE_JAR_NAME=${juice_jar_name} \
    --build-arg SCALA_BINARY_VERSION=${SCALA_BINARY_VERSION} \
    --build-arg AZURE_BLOB_NAME=${AZURE_BLOB_NAME} \
    -f ${base_dir}/dev/docker/engine/Dockerfile \
    ${base_dir}/dev
}

base_dir=$(cd "$(dirname $0)/../.." && pwd)
echo "Project base dir ${base_dir}"

# import environment variables from mlsql-functions
source "${base_dir}/dev/bin/mlsql-functions.sh"

#In the CI process, this special parameter is used to avoid repeated builds.
# If you are not using the build script in CI, you can use the default value regardless of this parameter.
STEP_01_BUILD_SANDBOX_IMAGE=${STEP_01_BUILD_SANDBOX_IMAGE:-false}
if [[ $STEP_01_BUILD_SANDBOX_IMAGE == "false" ]]; then
  build_byzer_lang_distribution
fi

build_image