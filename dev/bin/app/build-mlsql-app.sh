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
## Builds a mlsql standalone app; mlsql is packed with its dependencies
## and runs in a non distributed fashion.
##########################################################################
set -u
set -e
set -o pipefail

## Required environment variables:
# SPARK_VERSION       default to 2.4.3, <2.4.3 | 3.1.1>
export SPARK_VERSION=${1:-2.4.3}
if [[ ${SPARK_VERSION} != "2.4.3" && ${SPARK_VERSION} != "3.1.1"  ]]
then
  echo "Invalid SPARK_VERSION ${SPARK_VERSION}, Spark 2.4.3 or 3.1.1 is accepted"
  exit 1
fi

if [[ ${SPARK_VERSION} == "2.4.3" ]]
then
  export MLSQL_SPARK_VERSION=2.4
  scala_binary_version=2.11
  spark_dist="spark-${SPARK_VERSION}-bin-hadoop2.7"
else
  export MLSQL_SPARK_VERSION=3.0
  scala_binary_version=2.12
  spark_dist="spark-${SPARK_VERSION}-bin-hadoop3.2"
fi

## Build mlsql engine
base=$(cd "$(dirname "$0")"/../../.. && pwd)
cd ${base}/mlsql || exit 1
./dev/make-distribution.sh

## Untar spark distribution package
mlsql_sandbox_path="${base}/dev/docker/mlsql-sandbox"

if [[ ! -f "${mlsql_sandbox_path}/lib/${spark_dist}.tgz" ]]
then
  cat << EOF
Please put ${spark_dist}.tgz in directory: ${mlsql_sandbox_path}/lib
EOF
  exit 1
fi

tar -xf ${mlsql_sandbox_path}/lib/${spark_dist}.tgz -C "${base}/dev/bin/app"
rm -rf ${base}/dev/bin/app/spark
mv ${base}/dev/bin/app/${spark_dist} ${base}/dev/bin/app/spark

## Run assembly plugin to build mlsql standalone app
cd ${base} || exit 1
mvn package -DskipTests -P spark-${MLSQL_SPARK_VERSION} -P scala-${scala_binary_version}
