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
# This script build kolo-lang cli tar.
# Tar file name convention kolo-lang-${os}-amd64-${kolo_lang_version}.tar.gz
# Layout looks like:
#├── bin
#│ ├── mlsql                 ## kolo-cli
#│ └── start-mlsql-app.sh    ##
#├── libs          ## 3rd-party jars
#│ ├── ansj_seg-5.1.6.jar
#│ └── nlp-lang-1.7.8.jar
#├── main          ## kolo-lang uber jar
#│ └── streamingpro-mlsql-spark_2.4_2.11-2.1.0.jar
#├── plugin      ## kolo-lang plugins
#│ ├── mlsql-assert-2.4_2.11-0.1.0-SNAPSHOT.jar
#│ ├── mlsql-excel-2.4_2.11-0.1.0-SNAPSHOT.jar
#│ ├── mlsql-language-server-2.4_2.11-0.1.0-SNAPSHOT.jar
#│ └── mlsql-shell-2.4_2.11-0.1.0-SNAPSHOT.jar
#└── spark      ## Spark jars
#
# To build linux tar with Spark 3.1.1 tag v2.2.0  : build-mlsql-app.sh 3.1.1 v2.2.0 build linux
# To build mac tar with Spark 2.4.3 kolo-lang v2.2.0 tag : build-mlsql-app.sh 2.4.3 master no mac
##########################################################################

set -e
set -o pipefail

function download_plugins {
  local declare array plugins=(mlsql-excel mlsql-shell mlsql-assert mlsql-language-server)
  for p in ${plugins[@]}
  do
    [[ ! -f "${base}/dev/lib/${p}-${MLSQL_SPARK_VERSION}_${scala_binary_version}-0.1.0-SNAPSHOT.jar" ]] \
    && echo "Downloading ${p}-${MLSQL_SPARK_VERSION}_${scala_binary_version}-0.1.0-SNAPSHOT.jar" \
    && curl --retry 3 --location --request POST 'http://store.mlsql.tech/run' \
         --form 'action="downloadPlugin"' \
         --form "pluginName=\"${p}-${MLSQL_SPARK_VERSION}\"" \
         --form 'pluginType="MLSQL_PLUGIN"' \
         --form 'version="0.1.0-SNAPSHOT"' \
         --output "${base}/dev/lib/${p}-${MLSQL_SPARK_VERSION}_${scala_binary_version}-0.1.0-SNAPSHOT.jar"
    cp "${base}/dev/lib/${p}-${MLSQL_SPARK_VERSION}_${scala_binary_version}-0.1.0-SNAPSHOT.jar" "${target_dir}/plugin/"
  done
  echo "plugin download finished"
}

export SPARK_VERSION=${1:-2.4.3}
kolo_lang_tag=${2:master}
skip_build=${3:-NO}
## linux darwin win
os=${4:linux}
echo "OS ${os}"

if [[ ${SPARK_VERSION} != "2.4.3" && ${SPARK_VERSION} != "3.1.1"  ]]
then
  echo "Invalid SPARK_VERSION ${SPARK_VERSION}, Spark 2.4.3 or 3.1.1 is accepted"
  exit 1
fi

if [[ ${kolo_lang_tag} != "master" ]]
then
  echo "MLSQL_TAG ${kolo_lang_tag}"
  export MLSQL_TAG=${kolo_lang_tag}
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

## base -- kolo-build project base dir
base=$(cd "$(dirname "$0")"/../../.. && pwd)

## Infer kolo-lang version from ${base}/dev/kolo-lang/pom.xml
${base}/dev/bin/update-kolo-lang.sh || exit 1
cd "${base}/kolo-lang"
kolo_lang_version=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.version}' --non-recursive exec:exec)
echo "kolo-lang version ${kolo_lang_version}"
cd "${base}/dev/bin/app"

## Create dir
if [[ -z "${os}" || -z "${kolo_lang_version}" ]]
then
  echo "OS or kolo_lang_version is NULL, exit"
  exit 0
fi
target_dir="${base}/dev/lib/kolo-lang-${os}-amd64-${kolo_lang_version}"
echo "make dir ${target_dir}"
rm -rf "${target_dir}/*"
mkdir -p "${target_dir}/main"
mkdir -p "${target_dir}/bin"
mkdir -p "${target_dir}/libs"
mkdir -p "${target_dir}/plugin"
mkdir -p "${target_dir}/spark"

## Copy executables to ${target_dir}/bin/
## For now, please clone and make https://github.com/byzer-org/kolo-cli, and copy executables to dev/lib/
# TODO build kolo cli automatically
echo "copy kolo cli to ${target_dir}/bin/"
if [[ ${os} == "linux" ]]
then
  cp ${base}/dev/lib/mlsql-linux-amd64 "${target_dir}/bin/kolo"
elif [[ ${os} == "mac" ]]
then
  cp ${base}/dev/lib/mlsql-darwin-amd64 "${target_dir}/bin/kolo"
elif [[ ${os} == "win" ]]
then
  cp ${base}/dev/lib/mlsql-windows-amd64.exe "${target_dir}/bin/kolo"
else
  echo "unsupported os"
  exit 1
fi
cp "${base}/dev/bin/app/start-mlsql-app.sh" "${target_dir}/bin/"

echo "download plugins to ${target_dir}/plugin"
download_plugins

echo "Build kolo-lang - if required and copy kolo-lang uber jar to ${target_dir}/main/"
if [[ ${skip_build} != "skipBuild" ]]
then
  ( cd ${base}/dev/bin/ && source ./mlsql-functions.sh && build_kolo_lang_distribution )
fi
cp "${base}/kolo-lang/streamingpro-mlsql/target/streamingpro-mlsql-spark_${MLSQL_SPARK_VERSION}_${scala_binary_version}-${kolo_lang_version}.jar" "${target_dir}/main/"

echo  "copy 3rd-party jars to ${target_dir}/libs"
cp "${base}/dev/lib/ansj_seg-5.1.6.jar" "${target_dir}/libs/"
cp "${base}/dev/lib/nlp-lang-1.7.8.jar" "${target_dir}/libs/"

echo "copy spark jars "
rm -rf ${base}/dev/lib/${spark_dist}/*
tar -xf ${base}/dev/lib/${spark_dist}.tgz -C "${base}/dev/lib/"
sleep 2
( cd ${base}/dev/lib/${spark_dist}/jars && cp * "${target_dir}/spark/" )

tree -L 3 ${target_dir}

echo "build tar gz"
cd "${target_dir}/.."
tar -czf "kolo-lang-${os}-amd64-${kolo_lang_version}.tar.gz" "./kolo-lang-${os}-amd64-${kolo_lang_version}"
ls -l "kolo-lang-${os}-amd64-${kolo_lang_version}.tar.gz"
