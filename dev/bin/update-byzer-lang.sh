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

# Updates byzer-lang code. If MLSQL_TAG is specified, checkout it as branch ${tag}_branch;
# checkout & pull master branch otherwise

set -e
set -o pipefail

## Please check if MLSQL_TAG is null before calling this function
function checkout_tag {
    echo "Checking out byzer-lang ${MLSQL_TAG}"

    cd byzer-lang
    git tag | xargs -I {} git tag -d {}
    git reset --hard
    git checkout master
    git fetch origin
    [[ -z "`git branch | grep ${MLSQL_TAG}-branch`" ]] && echo "create new branch" || (echo "remove branch and create new" && git branch -D ${MLSQL_TAG}-branch)
    git checkout -b ${MLSQL_TAG}-branch ${MLSQL_TAG}
    echo $?
}

base=$(cd "$(dirname $0)/../.." && pwd)
cd "${base}"

if [[ ! -d byzer-lang/.git ]]; then
    echo "cloning byzer-lang repo..."
    git clone https://github.com/byzer-org/byzer-lang byzer-lang
    if [[ -n ${MLSQL_TAG} ]]; then
        checkout_tag
    else
      if [[ -n ${BYZER_LANG_BRANCH} ]]; then
          branch=${BYZER_LANG_BRANCH}
          cd byzer-lang && git checkout "$branch" && git pull -r origin "$branch"
      fi
    fi

else
    if [[ -n ${MLSQL_TAG} ]]; then
        checkout_tag
    else
        echo "update byzer-lang to latest..."
        branch=${BYZER_LANG_BRANCH:-master}
        ( cd byzer-lang && git checkout $branch && git pull -r origin $branch )
    fi
fi