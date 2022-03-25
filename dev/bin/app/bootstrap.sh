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

base=$(cd "$(dirname $0)/.." && pwd)
cd "$base" || return

[[ $# -lt 1 ]] && echo "Please usage: bootstrap <start|spawn>" && exit 1

if [ "$1" == "start" ] || [ "$1" == "spawn" ]
then
# start command
    echo "Starting Byzer-lang server..."
    MAIN_JAR=$(ls "${base}"/main | grep 'byzer-lang')
    echo ${MAIN_JAR}

    java -cp ${base}/main/${MAIN_JAR}:${base}/spark/*:${base}/libs/*:${base}/plugin/* \
    tech.mlsql.example.app.LocalSparkServiceApp \
    -streaming.plugin.clzznames tech.mlsql.plugins.ds.MLSQLExcelApp,tech.mlsql.plugins.assert.app.MLSQLAssert,tech.mlsql.plugins.shell.app.MLSQLShell,tech.mlsql.plugins.ext.ets.app.MLSQLETApp,tech.mlsql.plugins.mllib.app.MLSQLMllib
fi
