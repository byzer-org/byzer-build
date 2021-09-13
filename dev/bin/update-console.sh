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

# Updates mlsql-api-console code. If MLSQL_CONSOLE_TAG is specified,
# checkout it as branch ${tag}_branch; checkout & pull master branch
# otherwise
set +u
set -e
set -o pipefail

function checkout_tag {
    echo "Checking out ${MLSQL_CONSOLE_TAG}"

    cd console
    git tag | xargs -I {} git tag -d {}
    git reset --hard
    git checkout master
    git fetch origin
    [[ -z "`git branch | grep ${MLSQL_CONSOLE_TAG}-branch`" ]] && echo "create new branch" || (echo "remove branch and create new" && git branch -D ${MLSQL_CONSOLE_TAG}-branch)
    git checkout -b ${MLSQL_CONSOLE_TAG}-branch ${MLSQL_CONSOLE_TAG}
    echo $?
}

self=$(cd "$(dirname $0)/../.." && pwd)
cd "${self}" || exit 1

if [[ ! -d console/.git ]]; then
    echo "cloning console repo..."
    git clone https://github.com/allwefantasy/mlsql-api-console console
    if [[ -n ${MLSQL_CONSOLE_TAG} ]]; then
        checkout_tag
    fi
else
    if [[ -n ${MLSQL_CONSOLE_TAG} ]]; then 
        checkout_tag
    else
        echo "update console to latest..."
        ( cd console && git checkout master && git pull -r origin master )
    fi    
fi
