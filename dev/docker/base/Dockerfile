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
    curl wget unzip nano git net-tools vim && \
   localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
   rm -rf /var/lib/apt/lists/* && \
   mkdir -p /work && \
   wget "https://repo.huaweicloud.com/java/jdk/8u151-b12/jdk-8u151-linux-x64.tar.gz" && \
   tar -xvf jdk-8u151-linux-x64.tar.gz -C /work/ && \
   rm jdk-8u151-linux-x64.tar.gz

ENV JAVA_HOME /work/jdk1.8.0_151
ENV PATH /opt/conda/bin:$PATH:${JAVA_HOME}/bin

## Install conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile && \
    echo "conda activate base" >> /etc/profile && \
    . /etc/profile

## Install python packages
RUN  . /etc/profile && pip install --upgrade pip && \
    pip config set global.trusted-host mirrors.aliyun.com && \
    pip config set global.index-url http://mirrors.aliyun.com/pypi/simple/ && \
    pip install --upgrade Cython pytest-runner aioredis==1.3.1 pyarrow==5.0.0 ray==1.3.0 \
    aiohttp psutil grpcio pandas xlsxwriter watchdog requests click uuid sfcli \
    pyjava vega_datasets plotly setproctitle pyecharts matplotlib seaborn sklearn