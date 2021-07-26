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
## This script assumes that mlsql and mlsql-api-consule are pulled as git
## subtree; the sub-directory names are mlsql and console respectively.
## Maven and docker are required.
##
##########################################################################

set -u
set -e
set -o pipefail

## Environment variables used to build mlsql
export DISTRIBUTION=true
export DRY_RUN=false
export OSS_ENABLE=false
export DATASOURCE_INCLUDED=false
export ENABLE_JYTHON=true
export ENABLE_CHINESE_ANALYZER=true
export ENABLE_HIVE_THRIFT_SERVER=true

export MLSQL_SPARK_VERSION=${MLSQL_SPARK_VERSION:-2.4}
export SPARK_VERSION=${SPARK_VERSION:-2.4.3}
export MLSQL_VERSION=${MLSQL_VERSION:-2.1.0-SNAPSHOT}
export MLSQL_CONSOLE_VERSION=${MLSQL_CONSOLE_VERSION:-2.1.0-SNAPSHOT}

function exit_with_usage {
  cat << EOF
Usage: build-sandbox-image.sh
Arguments are specified with the following environment variable:
MLSQL_SPARK_VERSION    - the spark version, 2.3/2.4/3.0 default 2.4
SPARK_VERSION          - Spark full version, 2.4.3/   default 2.4.3
MLSQL_VERSION          - mlsql version  default 2.1.0-SNAPSHOT
MLSQL_CONSOLE_VERSION  - mlsql api console version default 2.1.0-SNAPSHOT
EOF
  exit 1
}

base_dir=$(cd $(dirname $0)/../.. && pwd)

scala_version=2.11
mlsql_path="${base_dir}/mlsql"
mlsql_console_path="${base_dir}/console"
base_image_path="${base_dir}/dev/docker/base"
mlsql_sandbox_path="${base_dir}/dev/docker/mlsql-sandbox"

## Check if mlsql and mlsql-api-console sub-directory exists
if [[ ! -d "${mlsql_path}" || ! -d "${mlsql_console_path}" ]]
then
  echo "mlsql or mlsql-api-console directory does not exist, exit"
  exit 1
fi
## Check if spark distribution package is in place
if [[ ! -f "${mlsql_sandbox_path}/lib/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz" ]]
then
  cat << EOF
Spark distribution spark-${SPARK_VERSION}-bin-hadoop2.7.tgz does not exist in
directory:${mlsql_sandbox_path}/lib
EOF
  exit 1
fi

## Check if two Dockerfiles exist
if [[ ! -f "${mlsql_sandbox_path}/Dockerfile" || ! -f "${base_image_path}/Dockerfile" ]]
then
  echo "Please make sure Dockerfiles are in place"
  exit 1
fi

## Check if jars are in place
if [[ ! -f "${mlsql_sandbox_path}/lib/ansj_seg-5.1.6.jar" || ! -f "${mlsql_sandbox_path}/lib/nlp-lang-1.7.8.jar" ]]
then
  echo << EOF
Please copy ansj_seg-5.1.6.jar and nlp-lang-1.7.8.jar to Docker build directory
Download url: http://download.mlsql.tech/nlp/
EOF
  exit 1
fi

## Make a soft link from nlp jars to mlsql/dev
ln -f -s ${mlsql_sandbox_path}/lib/ansj_seg-5.1.6.jar  ${mlsql_path}/dev/
ln -f -s ${mlsql_sandbox_path}/lib/nlp-lang-1.7.8.jar  ${mlsql_path}/dev/

## Builds mlsql engine tar ball
"${base_dir}"/mlsql/dev/make-distribution.sh

mlsql_engine_name="mlsql-engine_${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}.tar.gz"
## Check if tgz exists
if [[ ! -f "${mlsql_path}/${mlsql_engine_name}" ]]
then
  echo "mlsql engine failed to generate the tar ball, exit"
  exit 1
fi

## Copy mlsql files to directory: docker/mlsql-sandbox
cp ${mlsql_path}/${mlsql_engine_name} ${mlsql_sandbox_path}/lib/

## Build mlsql-api-console
mvn -f ${mlsql_console_path}/pom.xml clean compile package -DskipTests -Pshade

## Check if jar file exists
if [[ ! -f "${mlsql_console_path}/target/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar" ]]
then
  echo "mlsql-api-console failed to generate jar file, exit"
  exit 1
fi

## Copy files to directory: docker/mlsql-sandbox
cp ${mlsql_console_path}/target/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar ${mlsql_sandbox_path}/lib/

## Build docker images
cd "${base_image_path}"
docker build ./ -t mysql-python:8.0-3.6

cd "${mlsql_sandbox_path}"
docker build ./ \
--build-arg MLSQL_SPARK_VERSION=${MLSQL_SPARK_VERSION} \
--build-arg SPARK_VERSION=${SPARK_VERSION} \
--build-arg MLSQL_VERSION=${MLSQL_VERSION} \
--build-arg MLSQL_CONSOLE_VERSION=${MLSQL_CONSOLE_VERSION} \
-t mlsql-sandbox:${SPARK_VERSION}-${MLSQL_VERSION}

echo "mlsql sandbox image build finished, please run: run-container.sh"

