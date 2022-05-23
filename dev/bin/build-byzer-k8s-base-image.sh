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

export SPARK_VERSION=3.1.1
export BYZER_LANG_VERSION=${BYZER_LANG_VERSION:-2.3.0.1}
self=$(cd "$(dirname $0)" && pwd)
source "${self}/mlsql-functions.sh"

function exit_with_usage {
  cat << EOF
Usage: build-byzer-k8s-base-image.sh
Arguments are specified with the following environment variable:
BYZER_LANG_VERSION      - Byzer-lang version  default 2.3.0-SNAPSHOT
EOF
  exit 1
}

if [[ $@ == *"help"* ]]; then
    exit_with_usage
fi

# base_dir is assigned in mlsql-functions.sh, it refers to this project base dir
download_byzer_lang_related_jars &&
docker build -t byzer-lang-k8s-base:3.1.1-${BYZER_LANG_VERSION} -f "${base_dir}"/dev/k8s/base/Dockerfile "${base_dir}"/dev &&
exit 0