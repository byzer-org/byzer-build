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

# byzer-build root path
base_dir=$(cd "$(dirname $0)/../.." && pwd)
mlsql_console_path="${base_dir}/console"
byzer_notebook_path="${base_dir}/byzer-notebook"
base_image_path="${base_dir}/dev/docker/base"
byzer_sandbox_path="${base_dir}/dev/docker/byzer-sandbox"
lib_path="${base_dir}"/dev/lib
declare array plugins=(mlsql-excel mlsql-shell mlsql-assert mlsql-language-server mlsql-ext-ets mlsql-mllib )

# Many environment variables are inferred from SPARK_VERSION
export SPARK_VERSION=${SPARK_VERSION:-3.1.1}
export BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION:-1.0.2-SNAPSHOT}
export BYZER_NOTEBOOK_HOME=$byzer_notebook_path
export JUICEFS_VERSION=${JUICEFS_VERSION:-1.0.0}

export AUTO_DOWNLOAD_BYZER_LANG=${AUTO_DOWNLOAD_BYZER_LANG:-false}
export AUTO_DOWNLOAD_BYZER_RESOURCE=${AUTO_DOWNLOAD_BYZER_RESOURCE:-false}
export AUTO_DOWNLOAD_BYZER_PLUGINS=${AUTO_DOWNLOAD_BYZER_PLUGINS:-false}


os=${OS:-linux}

if [[ ${JUICEFS_VERSION} == "0.17.5" ]]
then
  export JUICEFS_JAR=juicefs-hadoop-0.17.5-linux-amd64.jar
elif [[ ${JUICEFS_VERSION} == "1.0.0" ]]
then
  export JUICEFS_JAR=juicefs-hadoop-1.0.0.jar
fi

if [[ ${SPARK_VERSION} == "2.4.3" ]]
then
    export SPARK_TGZ_NAME="spark-${SPARK_VERSION}-bin-hadoop2.7"
    export HADOOP_TGZ_NAME="hadoop-2.7.0"
    export AZURE_BLOB_NAME="azure-blob_2.7-1.0-SNAPSHOT.jar"
    export SCALA_BINARY_VERSION=2.11
    ## For byzer-extension jar name
    export BYZER_SPARK_VERSION=2.4
elif [[ ${SPARK_VERSION} == "3.1.1" ]]
then
    export SPARK_TGZ_NAME="spark-${SPARK_VERSION}-bin-hadoop3.2"
    export AZURE_BLOB_NAME="azure-blob_3.2-1.0-SNAPSHOT.jar"
    export HADOOP_TGZ_NAME="hadoop-3.2.3"
    export SCALA_BINARY_VERSION=2.12
    ## For byzer-extension jar name
    export BYZER_SPARK_VERSION=3.0
elif [[ ${SPARK_VERSION} == "3.3.0" ]]
then
    export SPARK_TGZ_NAME="spark-${SPARK_VERSION}-bin-hadoop3"
    export AZURE_BLOB_NAME="azure-blob_3.2-1.0-SNAPSHOT.jar"
    export HADOOP_TGZ_NAME="hadoop-3.2.3"
    export SCALA_BINARY_VERSION=2.12
    ## For byzer-extension jar name
    export BYZER_SPARK_VERSION=3.3
else
    echo "Only Spark 2.4.3/3.1.1/3.3.0 is supported"
    exit 1
fi

## Something went wrong, exit
if [[ ${base_dir} == "/" ]]
then
  echo "base_idr is ${base_dir}, please check your configuration"
  exit 1
fi

cat << EOF
BYZER_LANG_VERSION ${BYZER_LANG_VERSION}
SPARK_VERSION ${SPARK_VERSION}
BYZER_SPARK_VERSION ${BYZER_SPARK_VERSION}
AZURE_BLOB_NAME ${AZURE_BLOB_NAME}
SPARK_TGZ_NAME ${SPARK_TGZ_NAME}
HADOOP_TGZ_NAME ${HADOOP_TGZ_NAME}
SCALA_BINARY_VERSION ${SCALA_BINARY_VERSION}
BYZER_NOTEBOOK_VERSION ${BYZER_NOTEBOOK_VERSION}
JUICEFS_JAR ${JUICEFS_JAR}
os ${os}

AUTO_DOWNLOAD_BYZER_LANG ${AUTO_DOWNLOAD_BYZER_LANG}
AUTO_DOWNLOAD_BYZER_RESOURCE ${AUTO_DOWNLOAD_BYZER_RESOURCE}
AUTO_DOWNLOAD_BYZER_PLUGINS ${AUTO_DOWNLOAD_BYZER_PLUGINS}
EOF

function clean_lib_path {
  echo "lib_path ${lib_path}"
  [[ -z "${lib_path}" ]] && echo "lib_path is undefined, exit" && exit 1
  rm -rf "${lib_path:?}"/*
}

## Download byzer-lang, spark, hadoop, nlp , ansj , plugin
function download_byzer_lang_related_jars {
    # clean_lib_path || exit 1

    echo "Download open JDK8 from download.byzer.org"
    if [[ "${os}" == "linux" ]]
    then
      (
        local jdk_name="openjdk-8u332-b09-linux-x64"
        wget --no-check-certificate --no-verbose \
          "http://download.byzer.org/byzer/misc/jdk/jdk8/${jdk_name}.tar.gz" \
          --directory-prefix "${lib_path}/" &&
        tar -xf "${lib_path}/${jdk_name}.tar.gz" -C "${lib_path}" &&
        mv "${lib_path}"/openlogic-${jdk_name} "${lib_path}"/jdk8-${os}
      ) || exit 1
    elif [[ "${os}" == "win" ]]
    then
      (
        wget --no-check-certificate --no-verbose "http://download.byzer.org/byzer/misc/jdk/jdk8/openjdk-8u332-b09-windows-x64.zip" \
          --directory-prefix "${lib_path}" &&
        unzip -q -o "${lib_path}/openjdk-8u332-b09-windows-x64.zip" -d "${lib_path}/" &&
        mv "${lib_path}"/openlogic-openjdk-8u332-b09-windows-64 "${lib_path}"/jdk8-${os}
      ) || exit 1
    elif [[ "${os}" == "darwin" ]]
    then
      ## MacOS
      (
        wget --no-check-certificate --no-verbose "http://download.byzer.org/byzer/misc/jdk/jdk8/openjdk-8u332-b09-mac-x64.zip" \
            --directory-prefix "${lib_path}/" &&
        unzip -q -o "${lib_path}/openjdk-8u332-b09-mac-x64.zip" -d "${lib_path}/" &&
        mv "${lib_path}"/openlogic-openjdk-8u332-b09-mac-x64 "${lib_path}"/jdk8-${os} &&
        chmod +x "${lib_path}"/jdk8-${os}/Contents/Home/bin/java
      ) || exit 1
    else
      echo "No need to download jdk for ${os}"
    fi
    echo "JDK8 download succeed"

    ## Download Spark
    if [[ ${SPARK_VERSION} == "3.1.1" ]]
    then
      (
        ### Byzer-lang comes with higher version of velocity, so delete velocity-1.5.jar from Spark
        echo "Downloading Spark 3.1.1" &&
        wget --no-check-certificate --no-verbose --progress=dot \
          http://download.byzer.org/byzer/misc/spark/3.1.1/spark-3.1.1-bin-hadoop3.2.tgz \
          --directory-prefix "${lib_path}/" &&
        tar -zxf "${lib_path}"/spark-3.1.1-bin-hadoop3.2.tgz -C "${lib_path}" &&
        rm -f "${lib_path}"/spark-3.1.1-bin-hadoop3.2/jars/velocity-1.5.jar
      ) || exit 1
    fi

    if [[ ${SPARK_VERSION} == "2.4.3" ]]
    then
        (
          echo "Downloading Spark 2.4.3"
          rm -rf "${lib_path}"/spark-2.4.3-bin-hadoop2.7
          wget --no-check-certificate --no-verbose https://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz \
            --directory-prefix "${lib_path}/" || exit 1
          tar -zxf "${lib_path}"/spark-2.4.3-bin-hadoop2.7.tgz -C "${lib_path}" &&
          rm -f "${lib_path}"/spark-2.4.3-bin-hadoop2.7.tgz
        ) || exit 1
    fi

    if [[ ${SPARK_VERSION} == "3.3.0" ]]
    then
        (
          echo "Downloading Spark 3.3.0"
          rm -rf "${lib_path}"/spark-3.3.0-bin-hadoop3
          wget --no-check-certificate --no-verbose https://download.byzer.org/byzer/misc/spark/3.3.0/spark-3.3.0-bin-hadoop3.tgz \
            --directory-prefix "${lib_path}/" || exit 1
          tar -zxf "${lib_path}"/spark-3.3.0-bin-hadoop3.tgz -C "${lib_path}" &&
          rm -f "${lib_path}"/spark-3.3.0-bin-hadoop3.tgz
        ) || exit 1
    fi
    ## Download Hadoop
    if [[ ${SPARK_VERSION} == "3.1.1" || ${SPARK_VERSION} == "3.3.0" ]]
    then
      (
        echo "Downloading hadoop 3.2.3" &&
        cd "${lib_path}" &&
        local times_tried=0
        while [ $times_tried -le 3 ]; do
          echo "Downloading $times_tried"
          if wget --no-check-certificate --no-verbose https://download.byzer.org/byzer/misc/hadoop/hadoop-3.2.3.tar.gz && tar -zxf hadoop-3.2.3.tar.gz; then
            rm -rf "${lib_path}"/hadoop-3.2.3
            break
          fi
          if [[ $times_tried -ge 3 ]];then
            echo "Download hadoop-3.2.3.tar.gz failed!" && exit 1;
          fi
          times_tried=$((times_tried + 1))
          rm -rf hadoop-3.2.3.tar.gz
        done
      ) || exit 1
    fi
    ## Download Hadoop 2.7.0
    if [[ ${SPARK_VERSION} == "2.4.3" ]]
    then
      (
        echo "Downloading hadoop 2.7.0" &&
          cd "${lib_path}" &&
          local times_tried=0
        while [ $times_tried -le 3 ]; do
          echo "Downloading $times_tried"
          if curl -O https://archive.apache.org/dist/hadoop/core/hadoop-2.7.0/hadoop-2.7.0.tar.gz && tar -zxf hadoop-2.7.0.tar.gz; then
            rm -rf "${lib_path}"/hadoop-2.7.0
            break
          fi
          if [[ $times_tried -ge 3 ]];then
            echo "Download hadoop-2.7.0.tar.gz failed!" && exit 1;
          fi
          times_tried=$((times_tried + 1))
          rm -rf hadoop-2.7.0.tar.gz
        done
      ) || exit 1
    fi

    ( cd "${lib_path}" && curl -O https://download.byzer.org/byzer/misc/ansj_seg-5.1.6.jar ) || exit 1

    ( cd "${lib_path}" && curl -O https://download.byzer.org/byzer/misc/nlp-lang-1.7.8.jar ) || exit 1

    if [[ ${SPARK_VERSION} == "2.4.3" ]]
    then
      (
        wget --no-check-certificate --no-verbose "https://download.byzer.org/byzer/misc/cloud/azure/azure-blob_2.7-1.0-SNAPSHOT.jar" \
          --directory-prefix "${lib_path}/"
      ) || exit 1
    fi

    if [[ ${SPARK_VERSION} == "3.1.1" || ${SPARK_VERSION} == "3.3.0" ]]
    then
      (
        wget --no-check-certificate --no-verbose "https://download.byzer.org/byzer/misc/cloud/azure/azure-blob_3.2-1.0-SNAPSHOT.jar" \
          --directory-prefix "${lib_path}/"
      ) || exit 1
    fi


    # download_untar_byzer_lang || exit 1

    # download_byzer_plugin_jars || exit 1

    (
    echo "Downloading ${JUICEFS_JAR}" &&
    rm -f "${lib_path}"/"${JUICEFS_JAR}" &&
    wget --no-check-certificate --no-verbose \
     "https://download.byzer.org/byzer/misc/juicefs/${JUICEFS_JAR}" \
     --directory-prefix "${lib_path}/"
    ) || exit 1

}

function download_untar_byzer_lang {
    ## Download byzer-lang tar ball and extract it to dev/lib
    (
      echo "Downloading Byzer-lang tar ball from download.byzer.org"
      if [[ ${BYZER_LANG_VERSION} == *"-SNAPSHOT" ]]
      then
        wget --no-check-certificate --no-verbose "https://download.byzer.org/byzer/nightly-build/byzer-lang-${SPARK_VERSION}-latest.tar.gz" \
          --directory-prefix "${lib_path}" --output-document="${lib_path}/byzer-lang-${SPARK_VERSION}-${BYZER_LANG_VERSION}.tar.gz"
      else
        wget --no-check-certificate --no-verbose "https://download.byzer.org/byzer/${BYZER_LANG_VERSION}/byzer-lang-${SPARK_VERSION}-${BYZER_LANG_VERSION}.tar.gz" \
          --directory-prefix "${lib_path}"
      fi
    ) || exit 1
    ## In Dockerfile,  ADD byzer-lang.tar and mv byzer-lang... byzer-lang would result in two layers,
    ## making image size large. here, untar byzer-lang and rename its directory to byzer-lang.
    (
      tar -xf "${lib_path}/byzer-lang-${SPARK_VERSION}-${BYZER_LANG_VERSION}.tar.gz" -C "${lib_path}" &&
      mv "${lib_path}/byzer-lang-${SPARK_VERSION}-${BYZER_LANG_VERSION}" "${lib_path}/byzer-lang"
    ) || exit 1
}

function download_byzer_plugin_jars {
    ## Download plugins from download.byzer.org
    for p in "${plugins[@]}"
    do
      if [[ ! -f "${lib_path}/${p}-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar" ]]
      then
        echo "Downloading ${p}-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar"
        wget --no-check-certificate \
          --no-verbose \
          https://download.byzer.org/byzer-extensions/nightly-build/${p}-${BYZER_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
          --directory-prefix "${lib_path}/" || exit 1
      fi
    done
}

## Builds mlsql-api-console shade jar
function build_mlsql_api_console {
    ## Build mlsql-api-console
    "${base_dir}/dev/bin/update-console.sh" \
    && mvn -f ${mlsql_console_path}/pom.xml clean compile package -DskipTests -Pshade
    ## Check if jar file exists
    if [[ ! -f "${mlsql_console_path}/target/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar" ]]
    then
    echo "Failed to generate mlsql-api-console jar file, exit"
    exit 1
    fi
    cp "${mlsql_console_path}"/target/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar ${lib_path}/
}

## Builds byzer_notebook distribution package
function build_byzer_notebook {
    # Build byzer-notebook
    sh "${base_dir}/dev/bin/update-byzer-notebook.sh" && \
    bash "${byzer_notebook_path}"/build/package.sh skipTar

    # Check if build succeeds
    notebook_version=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout -f ${byzer_notebook_path}/pom.xml)
    echo "notebook path: ${base_dir}/byzer-notebook/dist/Byzer-Notebook-${notebook_version}"
    if [[ ! -d "${base_dir}/byzer-notebook/dist/Byzer-Notebook-${notebook_version}" ]]
    then
      echo "Failed to generate byzer-notebook distribution package, exit"
      exit 1
    fi
    # Remove the old then copy
    if [[ ! -z ${lib_path} && -d "${lib_path}/byzer-notebook" ]]
    then
      echo "Remove ${lib_path}/byzer-notebook"
      rm -rf "${lib_path}"/byzer-notebook
    fi
    # Get rid of BYZER_NOTEBOOK_VERSION from path; because human-set BYZER_NOTEBOOK_VERSION sometimes is incorrect
    echo "Copy byzer-notebook to ${lib_path}/byzer-notebook"
    cp -r "${byzer_notebook_path}/dist/Byzer-Notebook-${notebook_version}" "${lib_path}/byzer-notebook"
}
