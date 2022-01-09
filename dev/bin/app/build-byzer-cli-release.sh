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
# This script build byzer-lang cli tar.
# Tar file name convention byzer-lang-${os}-amd64-${byzer_lang_version}.tar.gz
# Layout looks like:
#├── bin
#│ ├── byzer                 ## byzer-cli
#│ └── start-mlsql-app.sh    ##
#├── libs          ## 3rd-party jars
#│ ├── ansj_seg-5.1.6.jar
#│ └── nlp-lang-1.7.8.jar
#|-- jdk8
#├── main                   ## byzer-lang uber jar
#│ └── streamingpro-mlsql-spark_2.4_2.11-2.1.0.jar
#├── plugin      ## kolo-lang plugins
#│ ├── mlsql-assert-2.4_2.11-0.1.0-SNAPSHOT.jar
#│ ├── mlsql-excel-2.4_2.11-0.1.0-SNAPSHOT.jar
#│ └── mlsql-shell-2.4_2.11-0.1.0-SNAPSHOT.jar
#└── spark      ## Spark jars
#
# To build linux tar for Spark 3.1.1  byzer-lang 2.3.0-SNAPSHOT : build-byzer-cli-release.sh 3.0  2.3.0-SNAPSHOT linux
##########################################################################

set -e
set -o pipefail

function print_usage {
  cat <<EOF
Parameter             examples
byzer_spark_version   3.0 2.4
byzer_lang_version    2.3.0-SNAPSHOT
OS                    linux win darwin
To build for byzer_lang 2.3.0-SNAPSHOT Spark 3.1.1 and mac(darwin)
$myself 3.0 2.3.0-SNAPSHOT darwin
EOF
  exit 0
}

## Current script name
myself=$(basename "$0")
## base -- kolo-build project base dir
base=$(cd "$(dirname "$0")"/../../.. && pwd)
## Byzer download base url
download_base_url="https://download.byzer.org/"

if [[ $# -lt 3 || $@ == *"help"* ]]
then
  print_usage
fi

byzer_spark_version=${1:-2.4}
byzer_lang_version=${2:-2.3.0-SNAPSHOT}
## linux darwin win
os=${3:linux}

if [[ ${byzer_spark_version} != "3.0" && ${byzer_spark_version} != "2.4"  ]]
then
  echo "Invalid byzer_spark_version ${byzer_spark_version}, 2.4 or 3.0 is accepted"
  exit 1
fi

if [[ ${os} != "darwin" && ${os} != "win" && ${os} != "linux" ]]
then
  echo "Invalid os ${os}, either of linux darwin win is accepted"
  exit 1
fi

[[ -z ${byzer_lang_version} ]] && echo "byzer_lang_version is empty" && exit 0

if [[ ${byzer_spark_version} == "3.0" ]]
  then
    scala_binary_version=2.12
  else
    scala_binary_version=2.11
fi

cat <<EOF
byzer_spark_version $byzer_spark_version
byzer_lang_version ${byzer_lang_version}
OS ${os}
EOF

function download_jdk8 {
  echo "Downloading jdk8"
  if [[ ${os} == "linux" ]]
  then
    wget --no-check-certificate --no-verbose "https://repo.huaweicloud.com/java/jdk/8u151-b12/jdk-8u151-linux-x64.tar.gz" \
      --directory-prefix "${target_dir}/tmp"
    tar -xf "${target_dir}/tmp/jdk-8u151-linux-x64.tar.gz" -C ${target_dir}
    mv ${target_dir}/jdk1.8.0_151 ${target_dir}/jdk8
    rm -f ${target_dir}/tmp/jdk-8u151-linux-x64.tar.gz
  elif [[ ${os} == "win" ]]
  then
    echo "Not implemented"
  fi

  echo "JDK8 download succeed"
}

function download_plugins {
  local declare array plugins=(mlsql-excel mlsql-shell mlsql-assert)
  for p in "${plugins[@]}"
  do
    echo "Downloading ${p}-${byzer_spark_version}-0.1.0-SNAPSHOT.jar"
    curl -D "${target_dir}/tmp/${p}.head" --retry 3 --location --request POST 'http://store.mlsql.tech/run' \
       --form 'action="downloadPlugin"' \
       --form "pluginName=\"${p}-${byzer_spark_version}\"" \
       --form 'pluginType="MLSQL_PLUGIN"' \
       --form 'version="0.1.0-SNAPSHOT"' \
       --output "${target_dir}/plugin/${p}-${byzer_spark_version}-0.1.0-SNAPSHOT.jar"
    if grep --silent '404 Not Found' "${target_dir}/tmp/${p}.head"; then  
        echo "${p}-${byzer_spark_version} is not found in plugin store" && exit 1
    fi
  done
  ## Copy language-server jar
  cp ${base}/dev/lib/mlsql-language-server-${byzer_spark_version}_${scala_binary_version}-0.1.0-SNAPSHOT.jar ${target_dir}/plugin/
  echo "plugin download succeed"
}

function download_cp_byzer_lang {
  echo "Downloading byzer lang ${byzer_lang_version}"
  local file="byzer-lang_${byzer_spark_version}-${byzer_lang_version}.tar.gz"
  local url="${download_base_url}/byzer/${byzer_lang_version}/byzer-lang/${file}"
  wget --no-check-certificate --no-verbose "${url}" --directory-prefix "${target_dir}/"
  if [[ ! -f "${target_dir}/${file}" ]]
  then
    echo "Failed to download byzer-lang"
    exit 1
  fi
  tar -xf "${target_dir}/byzer-lang_${byzer_spark_version}-${byzer_lang_version}.tar.gz" -C "${target_dir}/tmp"

  cp "${target_dir}/tmp/mlsql-engine_${byzer_spark_version}-${byzer_lang_version}/libs/streamingpro-mlsql-spark_${byzer_spark_version}_${scala_binary_version}-${byzer_lang_version}.jar" \
  "${target_dir}/main/"

  rm -f "${target_dir:?}/${file}"
  echo "Download & copy byzer-lang uber jar succeed"
}

function download_cli {
  if [[ ${os} == "darwin" ]]
  then
    local name="mlsql-darwin-amd64"
  elif [[ ${os} == "win" ]]
  then
    local name="mlsql-windows-amd64.exe"
  else
    local name="mlsql-linux-amd64"
  fi
  local url="${download_base_url}/cli/${name}"
  echo "wget --no-check-certificate --no-verbose ${url} --output-document ${target_dir}/bin/byzer"
  wget --no-check-certificate --no-verbose "${url}" --output-document "${target_dir}/bin/byzer"

  if [[ ! -f "${target_dir}/bin/byzer" ]]
  then
    echo "Download byzer cli failed"
    exit 1
  fi
  chmod +x ${target_dir}/bin/byzer
  echo "byzer cli download succeed"
}

function download_3rd_party_jars {
  wget --no-check-certificate --no-verbose "http://download.mlsql.tech/nlp/ansj_seg-5.1.6.jar" --directory-prefix "${target_dir}/libs/"
  wget --no-check-certificate --no-verbose http://download.mlsql.tech/nlp/nlp-lang-1.7.8.jar --directory-prefix "${target_dir}/libs/"
  echo  "Download 3rd-party jars succeed"
}

function download_spark_jars {
  [[ -z ${target_dir} ]] && echo "variable target_dir is not defined" && exit 1
  [[ ! -d "${target_dir}/tmp/" ]] && mkdir -p "${target_dir}/tmp/"

  if [[ ${byzer_spark_version} == "3.0" ]]
  then
    wget --no-check-certificate --no-verbose \
      https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz \
      --directory-prefix "${target_dir}/tmp/"
    tar -xf "${target_dir}/tmp/spark-3.1.1-bin-hadoop3.2.tgz" -C "${target_dir}/tmp/"
    sleep 2
    cp "${target_dir}/tmp/spark-3.1.1-bin-hadoop3.2/jars/"* "${target_dir}/spark/"
    if [[ ! -f "${target_dir}/spark/spark-core_2.12-3.1.1.jar" ]]
    then
      echo "Failed to download spark 3.1.1"
      exit 1
    fi
  fi

  if [[ ${byzer_spark_version} == "2.4" ]]
  then
    wget --no-check-certificate --no-verbose https://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz \
    --directory-prefix "${target_dir}/tmp/"
    tar -xf "${target_dir}/tmp/spark-2.4.3-bin-hadoop2.7.tgz" -C "${target_dir}/tmp/"
    sleep 2
    cp "${target_dir}/tmp/spark-2.4.3-bin-hadoop2.7.tgz/jars/"* "${target_dir}/spark/"
    if [[ ! -f "${target_dir}/spark/spark-core_2.11-2.4.3.jar" ]]
    then
      echo "Failed to download spark 2.4.3"
      exit 1
    fi
  fi

  [[ -d ${target_dir}/tmp ]] && rm -rf ${target_dir:?}/tmp/
  echo "Spark download succeed"
}

target_dir="${base}/dev/lib/byzer-lang-${os}-amd64-${byzer_spark_version}-${byzer_lang_version}"
echo "make dir ${target_dir}"
rm -rf ${target_dir:?}/
mkdir -p "${target_dir}/main"
mkdir -p "${target_dir}/bin"
mkdir -p "${target_dir}/libs"
mkdir -p "${target_dir}/plugin"
mkdir -p "${target_dir}/spark"
mkdir -p "${target_dir}/logs"
mkdir -p "${target_dir}/tmp"

download_jdk8

cp "${base}/dev/bin/app/start-mlsql-app.sh" "${target_dir}/bin/"
download_cli

download_plugins

download_cp_byzer_lang

download_3rd_party_jars

download_spark_jars

cd "${target_dir}/.."
tar -czf "byzer-lang-${os}-amd64-${byzer_spark_version}-${byzer_lang_version}.tar.gz" "./byzer-lang-${os}-amd64-${byzer_spark_version}-${byzer_lang_version}"
cat <<EOF
Build byzer cli release tar ball finished, file name byzer-lang-${os}-amd64-${byzer_spark_version}-${byzer_lang_version}.tar.gz
EOF

