#!/usr/bin/env bash

set -u
set -e
set -o pipefail

export BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION:-1.2.3}

base_dir=$(cd "$(dirname $0)/../.." && pwd)
echo "Project base dir ${base_dir}"


cat << EOF
BYZER_NOTEBOOK_VERSION ${BYZER_NOTEBOOK_VERSION}
EOF

rm -rf ${base_dir}/dev/k8s/notebook/byzer-notebook

cp -r ${base_dir}/dev/lib/byzer-notebook ${base_dir}/dev/k8s/notebook/

docker build -t byzer/byzer-notebook:${BYZER_NOTEBOOK_VERSION} \
-f "${base_dir}/dev/k8s/notebook/Dockerfile" \
"${base_dir}/dev/k8s/notebook"