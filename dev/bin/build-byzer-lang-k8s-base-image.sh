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
# run example:
# export BYZER_LANG_VERSION=2.3.0.1
# export OS=linux
# export JUICEFS_JAR=0.17.5
# ./dev/bin/build-byzer-lang-k8s-base-image.sh

set -u
set -e
set -o pipefail

export SPARK_VERSION=${SPARK_VERSION:-3.1.1}
export BYZER_LANG_VERSION=${BYZER_LANG_VERSION:-2.3.0-SNAPSHOT}
export JUICEFS_JAR=${JUICEFS_JAR:-juicefs-hadoop-0.17.5-linux-amd64.jar}
export SPARK_TGZ_NAME=${SPARK_TGZ_NAME:-spark-3.1.1-bin-hadoop3.2}
export KYLIN_BASE_IMAGE=${1:-"none"}

self=$(cd "$(dirname $0)" && pwd)
source "${self}/mlsql-functions.sh"

function exit_with_usage {
  cat << EOF
Usage: build-byzer-lang-k8s-base-image.sh
Arguments are specified with the following environment variable:
BYZER_LANG_VERSION      - Byzer-lang version  default 2.3.0-SNAPSHOT
JUICEFS_JAR             - JuiceFS jar         default juicefs-hadoop-0.17.5-linux-amd64.jar
SPARK_VERSION           - Spark version       default 3.1.1
SPARK_TGZ_NAME          - Spark tar ball      default spark-3.1.1-bin-hadoop3.2
BYZER_SPARK_VERSION     - Spark major version default 3.0
KYLIN_BASE_IMAGE        - kylin OS base image default none
EOF
  exit 1
}

if [[ $@ == *"help"* ]]; then
    exit_with_usage
fi

if [[ $BYZER_SPARK_VERSION == "3.3" ]]
then
  cp "${base_dir}"/dev/k8s/base/entrypoint-3.3.sh "${base_dir}"/dev/k8s/base/entrypoint.sh &&
  chmod +x "${base_dir}"/dev/k8s/base/entrypoint.sh
else
  cp "${base_dir}"/dev/k8s/base/entrypoint-3.1.sh "${base_dir}"/dev/k8s/base/entrypoint.sh &&
  chmod +x "${base_dir}"/dev/k8s/base/entrypoint.sh
fi

# base_dir is assigned in mlsql-functions.sh, it refers to this project base dir
# download_byzer_lang_related_jars &&
if [[ $KYLIN_BASE_IMAGE == "none" ]]
then
  docker build -t byzer/byzer-lang-k8s-base:"${SPARK_VERSION}-${BYZER_LANG_VERSION}" \
   --build-arg BYZER_SPARK_VERSION="${BYZER_SPARK_VERSION}" \
   --build-arg SPARK_VERSION="${SPARK_VERSION}" \
   --build-arg SPARK_TGZ_NAME="${SPARK_TGZ_NAME}" \
   --build-arg JUICEFS_JAR="${JUICEFS_JAR}" \
   -f "${base_dir}"/dev/k8s/base/Dockerfile \
   "${base_dir}"/dev &&
   exit 0
else
  #替换基础镜像
  sed -i "s/KYLIN_BASE_IMAGE/${KYLIN_BASE_IMAGE}/g" "${base_dir}"/dev/k8s/base/Dockerfile.kylin-amd64
  docker build -t byzer/byzer-lang-k8s-base:"${SPARK_VERSION}-${BYZER_LANG_VERSION}" \
   --build-arg BYZER_SPARK_VERSION="${BYZER_SPARK_VERSION}" \
   --build-arg SPARK_VERSION="${SPARK_VERSION}" \
   --build-arg SPARK_TGZ_NAME="${SPARK_TGZ_NAME}" \
   --build-arg JUICEFS_JAR="${JUICEFS_JAR}" \
   -f "${base_dir}"/dev/k8s/base/Dockerfile.kylin-amd64 \
   "${base_dir}"/dev &&
   exit 0
fi