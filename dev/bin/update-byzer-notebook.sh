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

# Updates byzer-notebook code. If BYZER_NOTEBOOK_TAG is specified,
# checkout it as branch ${tag}_branch; checkout & pull main branch
# otherwise
set +u
set -e
set -o pipefail

function checkout_tag {
    echo "Checking out ${BYZER_NOTEBOOK_TAG}"

    cd byzer-notebook
    git tag | xargs -I {} git tag -d {}
    git reset --hard
    git checkout main
    git fetch origin
    [[ -z "`git branch | grep ${BYZER_NOTEBOOK_TAG}-branch`" ]] && echo "create new branch" || (echo "remove branch and create new" && git branch -D ${BYZER_NOTEBOOK_TAG}-branch)
    git checkout -b ${BYZER_NOTEBOOK_TAG}-branch ${BYZER_NOTEBOOK_TAG}
    echo $?
}

self=$(cd "$(dirname $0)/../.." && pwd)
cd "${self}" || exit 1

if [[ ! -d byzer-notebook/.git ]]; then
    echo "cloning byzer-notebook repo..."
    git clone https://github.com/byzer-org/byzer-notebook.git byzer-notebook
    if [[ -n ${BYZER_NOTEBOOK_TAG} ]]; then
        checkout_tag
    else
        if [[ -n ${BYZER_NOTEBOOK_BRANCH} ]]; then
            branch=${BYZER_NOTEBOOK_BRANCH}
            cd byzer-notebook && git checkout "$branch" && git pull -r origin "$branch"
        fi
    fi
else
    if [[ -n ${BYZER_NOTEBOOK_TAG} ]]; then
        checkout_tag
    else
        echo "update byzer-notebook to latest..."
        branch=${BYZER_NOTEBOOK_BRANCH:-main}
        ( cd byzer-notebook && git checkout "${branch}" && git pull -r origin "${branch}" )
    fi    
fi
