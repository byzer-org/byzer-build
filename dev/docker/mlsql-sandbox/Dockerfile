## Assuming following packages reside in the ontext
## spark-${SPARK_VERSION}-bin-hadoop.2.7.tgz
## streamingpro_${SCALA_VERSION}_${MLSQL_VERSION}.tgz
## mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar
## MySQL root password is mlsql

FROM mysql-python:8.0-3.6

## Input arguments
ARG SPARK_VERSION
ARG SCALA_VERSION
ARG MLSQL_VERSION
ARG MLSQL_CONSOLE_VERSION

## Environment variables
ENV SPARK_VERSION ${SPARK_VERSION}
ENV SPARK_HOME /work/spark-${SPARK_VERSION}-bin-hadoop2.7
ENV BASE_DIR /home/deploy
ENV MLSQL_HOME ${BASE_DIR}/mlsql
ENV MLSQL_CONSOLE_VERSION ${MLSQL_CONSOLE_VERSION}
ENV MLSQL_CONSOLE_HOME ${BASE_DIR}/mlsql-console
ENV PATH=$PATH:${MLSQL_HOME}/bin:${MLSQL_CONSOLE_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin

## Creates directories
RUN mkdir -p /work/logs
RUN mkdir -p /work/user
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/libs
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/conf
RUN mkdir -p ${MLSQL_CONSOLE_HOME}/bin

## README.md
COPY README.md ${BASE_DIR}/

## Spark
ADD lib/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz /work
COPY conf/log4j.properties ${SPARK_HOME}/conf/

WORKDIR ${BASE_DIR}

## mlsql
ADD lib/"streamingpro_${SCALA_VERSION}_${MLSQL_VERSION}.tgz" ${BASE_DIR}/
RUN mv "streamingpro_${SCALA_VERSION}_${MLSQL_VERSION}" mlsql
COPY lib/ansj_seg-5.1.6.jar ${MLSQL_HOME}/libs/
COPY lib/nlp-lang-1.7.8.jar ${MLSQL_HOME}/libs/

# mlsql-api-console
COPY lib/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar ${MLSQL_CONSOLE_HOME}/libs/
COPY conf/application.docker.yml ${MLSQL_CONSOLE_HOME}/conf/
COPY bin/start-sandbox.sh ${BASE_DIR}/

ENTRYPOINT "${BASE_DIR}/start-sandbox.sh"
