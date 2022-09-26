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
## Builds Byzer-lang arure k8s image
##############################################################################
set -u
set -e
set -o pipefail

base_dir=$(cd "$(dirname $0)/../.." && pwd)
echo "Project base dir ${base_dir}"
export BYZER_LANG_VERSION=${BYZER_LANG_VERSION:-latest}
export SPARK_VERSION=${SPARK_VERSION:-3.1.1}
export AZURE_BLOB_NAME=${AZURE_BLOB_NAME:-azure-blob_3.2-1.0-SNAPSHOT.jar}
export HADOOP_S3_SHADE_JAR=${HADOOP_S3_SHADE_JAR:-aws-s3_3.3.1-1.0.1-SNAPSHOT.jar}


cat << EOF
BYZER_LANG_VERSION ${BYZER_LANG_VERSION}
AZURE_BLOB_NAME ${AZURE_BLOB_NAME}
SPARK_VERSION ${SPARK_VERSION}
EOF

docker build --no-cache -t byzer/byzer-lang-k8s:"${SPARK_VERSION}-${BYZER_LANG_VERSION:-latest}" \
--build-arg AZURE_BLOB_NAME="${AZURE_BLOB_NAME}" \
--build-arg HADOOP_S3_SHADE_JAR="${HADOOP_S3_SHADE_JAR}" \
--build-arg TAG="${SPARK_VERSION}-${BYZER_LANG_VERSION}" \
-f "${base_dir}/dev/k8s/all-in-one/Dockerfile" \
"${base_dir}/dev/k8s/all-in-one"