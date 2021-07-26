FROM mysql-python:8.0-3.6

## Input arguments
ARG SPARK_VERSION
ARG MLSQL_SPARK_VERSION
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
ADD lib/"mlsql-engine_${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}.tar.gz" ${BASE_DIR}/
RUN mv "mlsql-engine_${MLSQL_SPARK_VERSION}-${MLSQL_VERSION}" mlsql
COPY lib/ansj_seg-5.1.6.jar ${MLSQL_HOME}/libs/
COPY lib/nlp-lang-1.7.8.jar ${MLSQL_HOME}/libs/

# mlsql-api-console
COPY lib/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar ${MLSQL_CONSOLE_HOME}/libs/
COPY conf/application.docker.yml ${MLSQL_CONSOLE_HOME}/conf/
## Db init script
COPY bin/db_init.sh $BASE_DIR/
## Entrypoint script
COPY bin/start-sandbox.sh $BASE_DIR/

ENTRYPOINT $BASE_DIR/start-sandbox.sh
