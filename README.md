# mlsql-build

Project mlsql-build is designed to help people build MLSQL stack docker image easier

MLSQL Stack contains two projects:
1.  [MLSQL Engine](http://github.com/allwefantasy/mlsql)
2.  [MLSQL Console](http://github.com/allwefantasy/mlsql-api-console)

## Building MLSQL Sandbox
There are some manual steps before building:
1. Download [Latest Spark distribution](https://mirrors.tuna.tsinghua.edu.cn/apache/spark) or [Spark 2.4.3 Distribution](https://archive.apache.org/dist/spark/spark-2.4.3/)  and put it to dev/docker/mlsql-sandbox/lib
2. Download [NLP jars](http://download.mlsql.tech/nlp/) and put them to dev/docker/mlsql-sandbox/lib.
3. Pull the latest code/branch/tag from mlsql/console upstream. 
```shell
git subtree pull --prefix mlsql https://github.com/allwefantasy/mlsql master --squash
git subtree pull --prefix console https://github.com/allwefantasy/mlsql-api-console master --squash
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

Running MLSQL Sandbox
```shell
export SPARK_VERSION=2.4.3
export MLSQL_VERSION=2.1.0-SNAPSHOT
## Run container
./dev/bin/run-container.sh

```


## Environment Variables
````shell
export SPARK_VERSION=<2.4.3 || 3.1.1>
export SPARK_HOME=/work/spark-${SPARK_VERSION}-bin-hadoop2.7
export MLSQL_HOME=/home/deploy/mlsql
export MLSQL_CONSOLE_HOME=/home/deploy/mlsql-sonole
export PATH=$PATH:${MLSQL_HOME}/bin:${MLSQL_CONSOLE_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin
````

##Scripts
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