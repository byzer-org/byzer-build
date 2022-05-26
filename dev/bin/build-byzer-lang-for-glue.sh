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

# Builds Byzer-lang tar ball for Amazon Glue data catalog.
# For the Byzer-lang to access Glue, it should include:
# - Glue configuration in hive-site.xml
# - Amazon S3 configuration in core-site.xml
# - Amazon AccessKey and SecretKey
# - aws-glue-datacatalog-spark-client-3.4.0-SNAPSHOT.jar
# - hive-common and hive-exec-core with https://issues.apache.org/jira/secure/attachment/12958418/HIVE-12679.branch-2.3.patch
# - hadoop-common-3.3.2.jar & hadoop-aws-3.3.2.jar with jackson-databind com.thoughtworks.paranamer shaded. see details in https://github.com/byzer-org/byzer-objectstore-dep/tree/master/hadoop-common-aws
# - plugins
# Only byzer-lang-3.1.1-* is capable of accessing Glue.

function download_glue_jars() {
  echo "lib_path ${lib_path}"
  [[ -z "${lib_path}" ]] && echo "lib_path is undefined, exit" && exit 1

  echo "Download Glue related jars from download.byzer.org"
  (
    wget --no-check-certificate --no-verbose \
      https://download.byzer.org/byzer/misc/glue/aws-glue-datacatalog-spark-client-3.4.0-SNAPSHOT.jar \
      https://download.byzer.org/byzer/misc/glue/hadoop-common-aws-1.0-SNAPSHOT.jar \
      https://download.byzer.org/byzer/misc/glue/hive-common-2.3.7.jar \
      https://download.byzer.org/byzer/misc/glue/hive-exec-2.3.7-core.jar \
      --directory-prefix "${lib_path}"
  ) || exit 1
}

## Copy glue related jars and plugin to byzer-lang directory
function cp_tar_files() {
  echo "Start copying files to ${lib_path:?}/byzer-lang"

  cp "${lib_path}"/aws-glue-datacatalog-spark-client-3.4.0-SNAPSHOT.jar \
     "${lib_path}"/hadoop-common-aws-1.0-SNAPSHOT.jar \
     "${lib_path}"/hive-common-2.3.7.jar \
     "${lib_path}"/hive-exec-2.3.7-core.jar \
     "${lib_path}"/byzer-lang/libs/ || exit 1

  for p in "${plugins[@]}"
  do
    cp "${lib_path}/${p}"-"${BYZER_SPARK_VERSION}"_"${SCALA_BINARY_VERSION}"-0.1.0-SNAPSHOT.jar "${lib_path}"/byzer-lang/plugin/ || exit 1
  done

  (
    mv "${lib_path}"/byzer-lang "${lib_path}"/byzer-lang-"${SPARK_VERSION}"-"${BYZER_LANG_VERSION}"-glue &&
    cd "${lib_path}" &&
    tar -czf "${lib_path}"/../byzer-lang-"${SPARK_VERSION}"-"${BYZER_LANG_VERSION}"-glue.tar.gz \
        ./byzer-lang-"${SPARK_VERSION}"-"${BYZER_LANG_VERSION}"-glue
  ) || exit 1

}

self=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
## Import function and environment variables
source "${self}"/mlsql-functions.sh
clean_lib_path &&
download_untar_byzer_lang &&
download_byzer_plugin_jars &&
download_glue_jars &&
cp_tar_files
