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

MLSQL_CONSOLE_VERSION=${MLSQL_CONSOLE_VERSION:-2.1.0-SNAPSHOT}
MLSQL_CONSOLE_HOME=${MLSQL_CONSOLE_HOME:-/home/deploy/mlsql-console}
MLSQL_ENGINE_URL=${MLSQL_ENGINE_URL:-"http://127.0.0.1:9003"}

echo "Starting console"
echo "MLSQL_CONSOLE_VERSION ${MLSQL_CONSOLE_VERSION}"
echo "MLSQL_CONSOLE_HOME ${MLSQL_CONSOLE_HOME}"
echo "MLSQL_ENGINE_URL ${MLSQL_ENGINE_URL}"
echo -ex

## Start mlsql-api-console
java -cp ${MLSQL_CONSOLE_HOME}/libs/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar:./ tech.mlsql.MLSQLConsole \
-mlsql_engine_url ${MLSQL_ENGINE_URL} \
-my_url http://localhost:9002 \
-user_home /work/user/ \
-enable_auth_center false \
-config ${MLSQL_CONSOLE_HOME}/conf/application.yml
