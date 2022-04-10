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

## Init mysql
nohup ${BASE_DIR}/db_init.sh mysqld 2>&1 2>&1 > /work/logs/db_init.log &
## Start byzer lang engine
nohup ${BYZER_LANG_HOME}/bin/start-local.sh 2>&1 > /work/logs/engine.log &
## Start Ray
$CONDA_HOME/envs/ray1.8.0/bin/ray start --head --include-dashboard=false
## Wait for byzer lang startup
sleep 60
echo 'Waiting for mysql to be available.'
while ! mysqladmin ping -h"${DB_HOST:-127.0.0.1}" --silent; do
  echo "mysql health check failed, retrying in 1 seconds."
  sleep 1
done
echo "The mysql initialized successfully."

## Start byzer-notebook
"$BYZER_NOTEBOOK_HOME"/startup.sh hangup

