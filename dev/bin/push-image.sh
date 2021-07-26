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

export SPARK_VERSION=${SPARK_VERSION:-2.4.3}
export MLSQL_VERSION=${MLSQL_VERSION:-2.1.0-SNAPSHOT}
tag="${SPARK_VERSION}-${MLSQL_VERSION}"

function exit_with_usage {
  cat << EOF
push-image.sh <tag>
Set the following environment variables:
SPARK_VERSION - the spark version, 2.4/3.0 default 2.4
MLSQL_VERSION - MLSQL version              default 2.1.0-SNAPSHOT
EOF
  exit 1
}

if [[ $# -ne 1 ]]
then
  exit_with_usage
fi

tag=${SPARK_VERSION}-${MLSQL_VERSION}
repo=$1

docker login 

docker tag mlsql-sandbox:${tag} ${repo}:${tag}

docker images 

echo "Pushing to ${repo}"
docker push ${repo}:${tag}
