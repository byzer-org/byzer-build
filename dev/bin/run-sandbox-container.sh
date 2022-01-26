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

MYSQL_PASSWORD=${1:-root}
export SPARK_VERSION=${SPARK_VERSION:-3.1.1}
export BYZER_LANG_VERSION=${BYZER_LANG_VERSION:-latest}

function exit_with_usage {
  cat << EOF
Inputs are specified with the following environment variables:
SPARK_VERSION      - the spark version, 2.4/3.0 default 2.4
BYZER_LANG_VERSION - byzer-lang version, default latest
EOF
  exit 1
}

if [[ $@ == *"help"* ]]; then
  exit_with_usage
fi

docker run -d \
-p 3306:3306 \
-p 9002:9002 \
-p 9003:9003 \
-e MYSQL_ROOT_HOST=% \
-e MYSQL_ROOT_PASSWORD="${MYSQL_PASSWORD}" \
--name byzer-sandbox-${SPARK_VERSION}-${BYZER_LANG_VERSION:-latest} \
byzer/byzer-sandbox:${SPARK_VERSION}-${BYZER_LANG_VERSION:-latest}