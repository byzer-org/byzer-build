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

export MYSQL_ROOT_PASSWORD=${1:-root}
export MYSQL_PORT=${MYSQL_PORT:-3306}
export KOLO_LANG_PORT=${KOLO_LANG_PORT:-9003}
export BYZER_NOTEBOOK_PORT=${BYZER_NOTEBOOK_PORT:-9002}
export SPARK_VERSION=${SPARK_VERSION:-3.1.1}
export BYZER_LANG_VERSION=${BYZER_LANG_VERSION:-2.3.0-SNAPSHOT}
export BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION:-1.0.2-SNAPSHOT}

function exit_with_usage() {
  cat <<EOF
Inputs are specified with the following environment variables:
MYSQL_ROOT_PASSWORD    - the mysql root password        default root
MYSQL_PORT             - the mysql port                 default 3306
KOLO_LANG_PORT         - the kolo-lang port             default 9003
BYZER_NOTEBOOK_PORT    - the byzer notebook port        default 9002
SPARK_VERSION          - the spark version, 2.4/3.0     default 3.0
BYZER_LANG_VERSION     - Byzer-lang version             default 2.3.0-SNAPSHOT
BYZER_NOTEBOOK_VERSION - byzer notebook version         default 1.0.2-SNAPSHOT
EOF
  exit 1
}

if [[ $@ == *"help"* ]]; then
  exit_with_usage
fi

cd ${self}/../docker
docker-compose up -d
