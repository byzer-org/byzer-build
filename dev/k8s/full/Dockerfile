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

# The Dockerfile for Byzer-lang K8S azure image, adding azure-hadoop jar. This image includes
# OpenJDK8
# Spark 3.1.1-bin-hadoop3.2
# Byzer-lang
# Byzer-lang plugins
# azure-hadoop shade jar
# Directory structure
# |- /work
# |--- spark
# |--- jdk
# |- /home
# |--- deploy
# |------ byzer-lang
# |-------- plugin
# |-------- libs
# |-------- main
# |-------- bin
# |-------- logs

ARG TAG
FROM byzer/byzer-lang-k8s-base:$TAG

ADD https://download.byzer.org/byzer/misc/cloud/azure/byzer-objectstore-blob-3.3_2.12-0.1.0-SNAPSHOT.jar /home/deploy/byzer-lang/libs/
ADD https://download.byzer.org/byzer/misc/cloud/obs/byzer-objectstore-obs-3.3_2.12-0.1.0-SNAPSHOT.jar /home/deploy/byzer-lang/libs/
ADD https://download.byzer.org/byzer/misc/cloud/s3/byzer-objectstore-s3-3.3_2.12-0.1.0-SNAPSHOT.jar /home/deploy/byzer-lang/libs/
ADD https://download.byzer.org/byzer/misc/cloud/cos/byzer-objectstore-cos-3.3_2.12-0.1.0-SNAPSHOT.jar /home/deploy/byzer-lang/libs/
ADD https://download.byzer.org/byzer/misc/cloud/oss/byzer-objectstore-oss-3.3_2.12-0.1.0-SNAPSHOT.jar /home/deploy/byzer-lang/libs/
ADD https://download.byzer.org/byzer/misc/rss-shuffle-manager-1.0.0-shaded.jar $SPARK_HOME/jars