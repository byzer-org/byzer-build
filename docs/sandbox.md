# MLSQL Sandbox 
## Building MLSQL Sandbox
There are some manual steps before building:
1. Download [Spark 2.4.3 or 3.1.1 Distribution (hadoop-2.7 based)](https://archive.apache.org/dist/spark/)  and put it to dev/docker/mlsql-sandbox/lib
2. Download [NLP jars](http://download.mlsql.tech/nlp/) and put them to dev/docker/mlsql-sandbox/lib.
3. Pull the latest code/branch/tag from mlsql/console upstream.
```shell
./update-console.sh
./update-mlsql.sh
```   
4. Start building
```shell   
## For Spark 2.4.3 bundle
export MLSQL_SPARK_VERSION=2.4
export SPARK_VERSION=2.4.3
export MLSQL_VERSION=2.1.0-SNAPSHOT
export MLSQL_CONSOLE_VERSION=2.1.0-SNAPSHOT
./dev/bin/build-sandbox-image.sh

## For Spark 3.1.1 bundle
export MLSQL_SPARK_VERSION=3.0
export SPARK_VERSION=3.1.1
export MLSQL_VERSION=2.1.0-SNAPSHOT
export MLSQL_CONSOLE_VERSION=2.1.0-SNAPSHOT
./dev/bin/build-sandbox-image.sh
```
5. Check image
```shell
docker images
REPOSITORY      TAG                    IMAGE ID       CREATED          SIZE
mlsql-sandbox   2.4.3-2.1.0-SNAPSHOT   ba9013fa4dba   34 minutes ago   3.11GB
```

## Pushing Image to Docker hub
```shell
export SPARK_VERSION=2.4.3
export MLSQL_VERSION=2.1.0-SNAPSHOT
## Please enter username & password during execution
./dev/bin/push-image.sh <repo>
```

## Environment Variables
````shell
export SPARK_VERSION=<2.4.3 || 3.1.1>
export SPARK_HOME=/work/spark-${SPARK_VERSION}-bin-hadoop2.7
export MLSQL_HOME=/home/deploy/mlsql
export MLSQL_CONSOLE_HOME=/home/deploy/mlsql-sonole
export PATH=$PATH:${MLSQL_HOME}/bin:${MLSQL_CONSOLE_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin
````

## Scripts
```shell
/home/deploy/start-sandbox.sh
$MLSQL_HOME/bin/start-local.sh
```

## Directory Structure
```shell
|-- /work/
        |-- logs/  
        |-- users/
        |-- spark-${SPARK_VERSION}-bin-hadoop2.7/
|-- /home/deploy/
        |-- README.md
        |-- mlsql/
            |-- bin/                          
            |-- conf/                         
            |-- libs/                         
        |-- mlsql-console/                   
            |-- bin/                          
            |-- conf/                         
            |-- libs/    
```

## Installed software
- MySQL 8 Community Server
- OpenJDK 8
- Python 3.6
- PyJava 0.2.8.8
- Ray 1.3.0
- Pandas
- PyArrow