FROM ubuntu/mysql:8.0-20.04_beta

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends locales \
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

RUN mkdir ~/.pip
RUN echo "[global]\n trusted-host = mirrors.aliyun.com\n index-url = https://mirrors.aliyun.com/pypi/simple" > ~/.pip/pip.conf

## Install python packages
RUN  . /etc/profile && pip install --upgrade pip && pip install --no-cache-dir \
Cython numpy pandas scikit-learn plotly ray[default]==1.3.0 \
watchdog requests click uuid sfcli \
aiohttp psutil setproctitle grpcio xlsxwriter \
watchdog requests click uuid sfcli pyjava>=0.2.8.8 \
pyarrow

## Copy db init.sql
COPY db_init.sql /docker-entrypoint-initdb.d/
