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

base_dir=$(cd "$(dirname $0)/../.." && pwd)
scala_version=2.11
mlsql_path="${base_dir}/mlsql"
mlsql_console_path="${base_dir}/console"
base_image_path="${base_dir}/dev/docker/base"
mlsql_sandbox_path="${base_dir}/dev/docker/mlsql-sandbox"
lib_path=${base_dir}/dev/lib

# Used by make-distribution.sh
export DISTRIBUTION=true
export DRY_RUN=false
export OSS_ENABLE=false
export DATASOURCE_INCLUDED=false
export ENABLE_JYTHON=true
export ENABLE_CHINESE_ANALYZER=true
export ENABLE_HIVE_THRIFT_SERVER=true
# Spark major version, Used by make-distribution.sh
export MLSQL_SPARK_VERSION=${MLSQL_SPARK_VERSION:-2.4}
# Spark version, Used by make-distribution.sh
export SPARK_VERSION=${SPARK_VERSION:-2.4.3}
export MLSQL_VERSION=${MLSQL_VERSION:-2.2.0-SNAPSHOT}
export MLSQL_CONSOLE_VERSION=${MLSQL_CONSOLE_VERSION:-2.2.0-SNAPSHOT}
if [[ ${SPARK_VERSION} == "2.4.3" ]]
then
    export SPARK_TGZ_NAME="spark-${SPARK_VERSION}-bin-hadoop2.7"
elif [[ ${SPARK_VERSION} == "3.1.1" ]]
then
    export SPARK_TGZ_NAME="spark-${SPARK_VERSION}-bin-hadoop3.2"
else
    echo "Only Spark 2.4.3 or 3.1.1 is supported"
    exit 1
fi

## Builds mlsql distribution tar ball
function build_mlsql_distribution {
    ## Download jars & packages if needed
    if [[ ! -f "${lib_path}/${SPARK_TGZ_NAME}.tgz" && ${SPARK_VERSION} == "3.1.1" ]]
    then
      (
        echo "Downloading Spark 3.1.1" &&
        cd "${lib_path}" &&
        curl -O https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz
      ) || exit 1
    fi

    if [[ ! -f "${lib_path}/${SPARK_TGZ_NAME}.tgz" && ${SPARK_VERSION} == "2.4.3" ]]
    then
        (
          echo "Downloading Spark 2.4.3" &&
          cd "${lib_path}" &&
          curl -O https://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
        ) || exit 1
    fi

    if [[ ! -f "${lib_path}/ansj_seg-5.1.6.jar" ]]
    then
      ( cd "${lib_path}" && curl -O http://download.mlsql.tech/nlp/ansj_seg-5.1.6.jar ) || exit 1
    fi

    if [[ ! -f "${lib_path}/nlp-lang-1.7.8.jar" ]]
    then
      ( cd "${lib_path}" && curl -O http://download.mlsql.tech/nlp/nlp-lang-1.7.8.jar ) || exit 1
    fi

    "${base_dir}/dev/bin/update-mlsql.sh" || exit 1
    ## Make a soft link from nlp jars to mlsql/dev
    mkdir -p ${mlsql_path}/dev
    ln -f -s ${lib_path}/ansj_seg-5.1.6.jar  ${mlsql_path}/dev/
    ln -f -s ${lib_path}/nlp-lang-1.7.8.jar  ${mlsql_path}/dev/

    ## Builds mlsql engine tar ball
    "${mlsql_path}/dev/make-distribution.sh"
    return_code=$?
    if [[ ${return_code} != 0 ]]
    then
      exit ${return_code}
    fi
    mlsql_engine_name="mlsql-engine_${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}.tar.gz"
    ## Check if tgz exists
    if [[ ! -f "${mlsql_path}/${mlsql_engine_name}" ]]
    then
      echo "Failed to generate mlsql engine tar ball, exit"
      exit 1
    fi

    cp ${mlsql_path}/${mlsql_engine_name} ${lib_path}/
}

## Builds mlsql-api-consol shade jar
function build_mlsql_api_console {
    ## Build mlsql-api-console
    "${base_dir}/dev/bin/update-console.sh" \
    && mvn -f ${mlsql_console_path}/pom.xml clean compile package -DskipTests -Pshade
    ## Check if jar file exists
    if [[ ! -f "${mlsql_console_path}/target/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar" ]]
    then
    echo "Failed to generate mlsql-api-console jar file, exit"
    exit 1
    fi
    cp ${mlsql_console_path}/target/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar ${lib_path}/
}
