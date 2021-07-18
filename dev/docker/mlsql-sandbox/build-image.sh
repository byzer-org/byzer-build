#!/usr/bin/env bash

export SPARK_VERSION=${SPARK_VERSION:-2.4.3}
export MLSQL_VERSION=${MLSQL_VERSION:-2.1.0-SNAPSHOT}
export MLSQL_CONSOLE_VERSION=${MLSQL_CONSOLE_VERSION:-2.1.0-SNAPSHOT}
scala_version=2.11

docker build ./ \
--build-arg SPARK_VERSION=${SPARK_VERSION} \
--build-arg MLSQL_VERSION=${MLSQL_VERSION} \
--build-arg MLSQL_CONSOLE_VERSION=${MLSQL_CONSOLE_VERSION} \
--build-arg SCALA_VERSION=${scala_version} \
-t mlsql-sandbox:${MLSQL_VERSION}
