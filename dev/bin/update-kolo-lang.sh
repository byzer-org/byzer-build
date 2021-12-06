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

# Updates kolo-lang code. If MLSQL_TAG is specified, checkout it as branch ${tag}_branch;
# checkout & pull master branch otherwise

set -e
set -o pipefail

## Please check if MLSQL_TAG is null before calling this function
function checkout_tag {
    echo "Checking out kolo-lang ${MLSQL_TAG}"

    cd kolo-lang
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

if [[ ! -d kolo-lang/.git ]]; then
    echo "cloning kolo-lang repo..."
    git clone https://github.com/byzer-org/kolo-lang kolo-lang
    if [[ -n ${MLSQL_TAG} ]]; then
        checkout_tag
    fi
else
    if [[ -n ${MLSQL_TAG} ]]; then
        checkout_tag
    else
        echo "update kolo-lang to latest..."
        ( cd kolo-lang && git checkout master && git pull -r origin master )
    fi
fi