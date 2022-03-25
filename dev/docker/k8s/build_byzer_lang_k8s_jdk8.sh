#!/bin/bash

function exit_with_usage {
  cat << EOF
Environment variables
BYZER_LANG_VERSION               Byzer-lang version               default latest
EOF
  exit 0
}

[[ -z ${BYZER_LANG_VERSION} ]] && exit_with_usage

if [[ ${BYZER_LANG_VERSION} == "latest" ]]
then
  DOWNLOAD_DIR="nightly-build"
else
  DOWNLOAD_DIR="${BYZER_LANG_VERSION}"
fi
echo ${DOWNLOAD_DIR}

docker build -t byzer/byzer-lang-k8s-jdk8:3.1.1-${BYZER_LANG_VERSION:-latest} \
      --build-arg BYZER_LANG_VERSION=${BYZER_LANG_VERSION} \
      --build-arg DOWNLOAD_DIR=${DOWNLOAD_DIR:-nightly-build} \
      -f ./Dockerfile \
      ./
