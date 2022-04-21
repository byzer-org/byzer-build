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

## Init mysql
echo "Starting MySQL"
nohup ${BASE_DIR}/db_init.sh mysqld 2>&1 > /work/logs/db_init.log &
## Start byzer lang engine
echo "Calling byzer.sh to run Byzer-lang as daemon"
${BYZER_LANG_HOME}/bin/byzer.sh start

## Start Ray
$CONDA_HOME/envs/ray1.8.0/bin/ray start --head --include-dashboard=false
sleep 30
echo 'Waiting for MySQL and Byzer-lang to be ready.'
while ! mysqladmin ping -h"${DB_HOST:-127.0.0.1}" --silent; do
  echo "mysql health check failed, retrying in 1 seconds."
  sleep 1
done
echo "The MySQL is ready."

lang_ready=0
while [[ ${lang_ready} == 0 ]]
do
  lang_ready=$(curl -i --silent http://127.0.0.1:9003/health/readiness | grep "200" | wc -l)
  sleep 5
done
echo "Byzer-lang is ready"

## Start byzer-notebook
"$BYZER_NOTEBOOK_HOME"/startup.sh hangup

