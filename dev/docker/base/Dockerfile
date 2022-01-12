FROM ubuntu-baseimage

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 DEBIAN_FRONTEND=noninteractive
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
   wget "https://repo.huaweicloud.com/java/jdk/8u151-b12/jdk-8u151-linux-x64.tar.gz" && \
   tar -xvf jdk-8u151-linux-x64.tar.gz -C /work/ && \
   rm jdk-8u151-linux-x64.tar.gz

ENV JAVA_HOME /work/jdk1.8.0_151
ENV CONDA_HOME /opt/conda
ENV PATH=$CONDA_HOME/bin:$PATH:${JAVA_HOME}/bin


## Install conda.
## ray/issues/19938: In ray>=1.8.0 version, python3.6.11 or python3.7.10 should be used.
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_HOME && \
    rm ~/miniconda.sh && \
    ln -s $CONDA_HOME/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". $CONDA_HOME/etc/profile.d/conda.sh" >> /etc/profile && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo ". activate && conda activate" >> /etc/profile && \
    echo ". activate && conda activate" >> ~/.bashrc && \
    . /etc/profile && \
    pip config set global.trusted-host mirrors.aliyun.com && \
    pip config set global.index-url http://mirrors.aliyun.com/pypi/simple/ && \
    conda create -y --name ray1.8.0 python=3.6.13 && conda activate ray1.8.0 && pip install --upgrade pip && \
    pip install --upgrade pyarrow==4.0.1 "ray[default]==1.8.0" aiohttp==3.7.4 "pandas~=1.0.5" requests  \
             "matplotlib~=3.3.4" "uuid~=1.30" pyjava opencv-python pyecharts matplotlib seaborn sklearn keras tensorflow && \
    $CONDA_HOME/bin/conda clean -tipsy -a && \
    echo "conda activate ray1.8.0" >> /etc/profile && \
    echo "conda activate ray1.8.0" >> ~/.bashrc && \
    . /etc/profile