FROM ubuntu:22.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/work/jdk8 \
    CONDA_HOME=/opt/conda
## To make CONDA_HOME & JAVA_HOME evaluated, we need another ENV command.
ENV PATH=$CONDA_HOME/bin:$PATH:${JAVA_HOME}/bin

SHELL ["/bin/bash", "-c"]

# RUN apt-get update && apt-get install apt-transport-https && apt-get -y install ca-certificates

# RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list  \
#     && echo "deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list

RUN set -ex \
   && apt-get update \
   && apt-get install -y locales tini wget vim curl \
   && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
   && rm -rf /var/lib/apt/lists/*   

COPY environment.yml /work/
COPY jdk8-linux /work/jdk8

## RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh

RUN  mkdir -p /root/.pip
COPY pip.conf /root/.pip/

COPY miniconda.sh /root/

## Install Conda Ray
## Activate Ray 1.12.0 by default
## ray/issues/19938: In ray>=1.8.0 version, python3.6.11 or python3.7.10 should be used.
RUN chmod u+x /root/miniconda.sh && \
    /bin/bash /root/miniconda.sh -b -p $CONDA_HOME && \
    rm /root/miniconda.sh && \
    ln -s $CONDA_HOME/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /root/.bashrc    
    
RUN source /etc/profile && conda env create --file /work/environment.yml && \
    conda activate ray-1.12.0 && \
    $CONDA_HOME/bin/conda clean -tipsy -a && \
    echo "conda activate ray-1.12.0" >> /etc/profile && \
    echo "conda activate ray-1.12.0" >> /root/.bashrc && \
    . /etc/profile && \
    ln -fs /bin/bash /bin/sh    