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

# The Dockerfile for Byzer-lang K8S JDK8 image
FROM ubuntu:20.04 AS ubuntu-conda

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN set -ex \
   && apt-get update \
   && apt-get install -y locales tini wget curl net-tools vim \
   && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
   && rm -rf /var/lib/apt/lists/* \
   && mkdir -p /work/bin
## Install conda
ADD https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh /work/bin/miniconda.sh
RUN /bin/bash /work/bin/miniconda.sh -b -p /opt/conda && \
    rm /work/bin/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile && \
    echo "conda activate base" >> /etc/profile && \
    . /etc/profile

## Add aliyun pip mirror
## Install Ray 1.8.0
RUN mkdir ~/.pip && \
    echo "[global]\n trusted-host = mirrors.aliyun.com\n index-url = https://mirrors.aliyun.com/pypi/simple" > ~/.pip/pip.conf && \
    . /etc/profile && \
    conda create -y -n dev python=3.6.13 && \
    conda activate dev && \
    pip install --upgrade pip && \
    pip install --no-cache-dir \
      Cython numpy scikit-learn plotly ray[default]==1.8.0 \
      watchdog requests click uuid sfcli \
      psutil setproctitle grpcio xlsxwriter \
      watchdog requests click uuid sfcli pyjava>=0.2.8.8 pyarrow==4.0.1 \
      aiohttp==3.7.4 pandas>=1.0.5 matplotlib~=3.3.4 uuid~=1.30

FROM ubuntu-conda AS byzer-lang-k8s-jdk8

ARG BYZER_LANG_VERSION=latest
ARG DOWNLOAD_DIR=nightly-build

ENV BASE_DIR /work/server
ENV MLSQL_HOME ${BASE_DIR}/byzer-lang
ENV JAVA_HOME /work/server/byzer-lang/jdk8
ENV SPARK_HOME /work/server/byzer-lang/spark
ENV PATH=$PATH:${JAVA_HOME}/bin:${MLSQL_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin:/opt/conda/bin

# Byzer-lang
RUN mkdir -p /work/server/
ADD https://download.byzer.org/byzer/${DOWNLOAD_DIR}/byzer-lang-all-in-one-linux-amd64-3.1.1-${BYZER_LANG_VERSION}.tar.gz /work/server/
RUN tar -xf /work/server/byzer-lang-all-in-one-linux-amd64-3.1.1-${BYZER_LANG_VERSION}.tar.gz -C /work/server \
    && mv /work/server/byzer-lang-all-in-one-linux-amd64-3.1.1-2.3.0-SNAPSHOT /work/server/byzer-lang
COPY ./entrypoint.sh /work/bin/

ENTRYPOINT [ "/work/bin/entrypoint.sh" ]
