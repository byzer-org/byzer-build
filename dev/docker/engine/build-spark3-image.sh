#!/bin/bash

docker build -t mlsql-engine:3.0-2.1.0-SNAPSHOT \
--build-arg SPARK_VERSION=3.1.1 \
--build-arg MLSQL_SPARK_VERSION=3.0 \
--build-arg MLSQL_VERSION=2.1.0-SNAPSHOT \
-f engine/Dockerfile \
.
