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

# 环境变量:
# SPARK_HOME
# MLSQL_HOME
#
# Arguments:
# K8S API Server and port

set -u
set -e
set -o pipefail

MLSQL_SPARK_VERSION=${MLSQL_SPARK_VERSION:-3.0}
MLSQL_VERSION=${MLSQL_VERSION:-2.1.0-SNAPSHOT}

if [[ ${MLSQL_SPARK_VERSION} = "2.3" || ${MLSQL_SPARK_VERSION} = "2.4" ]]
then
  scala_version=2.11
elif [[ ${MLSQL_SPARK_VERSION} = "3.0" ]]
then
  scala_version=2.12
else
  echo "Spark-${MLSQL_SPARK_VERSION} is not supported"
  exit 1
fi

container_lib_path="local:///home/deploy/mlsql/libs/"
mlsql_jar="${container_lib_path}/streamingpro-mlsql-spark_${MLSQL_SPARK_VERSION}_${scala_version}-${MLSQL_VERSION}.jar"
auxiliary_jars="${container_lib_path}/juicefs-hadoop-0.15.2-linux-amd64.jar:${container_lib_path}/ansj_seg-5.1.6.jar:${container_lib_path}/nlp-lang-1.7.8.jar"
K8S_URL=${K8S_URL:-https://localhost:6443}
image="mlsql-engine:${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}"

echo "SPARK_HOME ${SPARK_HOME}"
echo "Jar ${mlsql_jar}"
echo "Image ${image}"
echo " "

DRIVER_MEMORY=${DRIVER_MEMORY:-1g}
$SPARK_HOME/bin/spark-submit --class streaming.core.StreamingApp \
        --master k8s://${K8S_URL} \
        --deploy-mode cluster \
        --name mlsql \
        --conf "spark.kubernetes.container.image=${image}" \
        --driver-memory ${DRIVER_MEMORY} \
        --executor-memory 1G \
        --conf "spark.executor.instances=1" \
        --conf "spark.sql.hive.thriftServer.singleSession=true" \
        --conf "spark.kryoserializer.buffer=256k" \
        --conf "spark.kryoserializer.buffer.max=1024m" \
        --conf "spark.serializer=org.apache.spark.serializer.KryoSerializer" \
        --conf "spark.scheduler.mode=FAIR" \
        --driver-library-path "${auxiliary_jars}" \
        --conf spark.executor.extraLibraryPath="${auxiliary_jars}" \
				--verbose \
        ${mlsql_jar} \
        -streaming.name mlsql \
        -streaming.platform spark \
        -streaming.rest true \
        -streaming.driver.port 9003 \
        -streaming.spark.service true \
        -streaming.thrift false \
        -streaming.enableHiveSupport true
