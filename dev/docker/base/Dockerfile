## ubuntu-baseimage: ubuntu20 with MySQL 8
# repo mysql-python:8.0-3.6
FROM ubuntu-baseimage

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/work/openjdk-8u332 \
    CONDA_HOME=/opt/conda
## To make CONDA_HOME & JAVA_HOME evaluated, we need another ENV command.
ENV PATH=$CONDA_HOME/bin:$PATH:${JAVA_HOME}/bin

SHELL ["/bin/bash", "-c"]

## Install basic software and OpenJDK 8
RUN rm -rf /var/lib/apt/lists/*  \
    && apt-get clean \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz \
    && apt-get update \
    && apt-get \
    -o Acquire::BrokenProxy="true" \
    -o Acquire::http::No-Cache="true" \
    -o Acquire::http::Pipeline-Depth="0" install \
    -y --no-install-recommends --fix-missing locales \
    apt-utils build-essential software-properties-common  \
    curl wget unzip nano git net-tools vim lrzsz && \
   localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
   rm -rf /var/lib/apt/lists/* && \
   mkdir -p /work && \
   wget --quiet "http://download.byzer.org/byzer/misc/jdk/jdk8/openjdk-8u332-b09-linux-x64.tar.gz" && \
   tar -xf openjdk-8u332-b09-linux-x64.tar.gz -C /work/ && \
   mv /work/openlogic-openjdk-8u332-b09-linux-x64 /work/openjdk-8u332 && \
   rm openjdk-8u332-b09-linux-x64.tar.gz

COPY environment.yml /work/

## Install Conda Ray
## Activate Ray 1.12.0 by default
## ray/issues/19938: In ray>=1.8.0 version, python3.6.11 or python3.7.10 should be used.
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_HOME && \
    rm ~/miniconda.sh && \
    ln -s $CONDA_HOME/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    . /etc/profile && \
    conda env create --file /work/environment.yml && \
    conda activate ray-1.12.0 && \
    $CONDA_HOME/bin/conda clean -tipsy -a && \
    echo "conda activate ray-1.12.0" >> /etc/profile && \
    echo "conda activate ray-1.12.0" >> ~/.bashrc && \
    . /etc/profile && \
    ln -fs /bin/bash /bin/sh