# Byzer Sandbox

## Building Byzer Sandbox

There are some manual steps before building:

1. Download [Spark 2.4.3(hadoop-2.7 based) or 3.1.1(hadoop-3.2 based) Distribution](https://archive.apache.org/dist/spark/)  and put it to dev/docker/mlsql-sandbox/lib

2. Download [NLP jars](https://download.byzer.org/byzer/misc/) and put them to dev/docker/byzer-sandbox/lib.

3. Start building

```shell   
## For Spark 2.4.3 bundle
export MLSQL_SPARK_VERSION=2.4
export SPARK_VERSION=2.4.3
export BYZER_LANG_VERSION=2.3.0-SNAPSHOT
export BYZER_NOTEBOOK_VERSION=1.0.2-SNAPSHOT
./dev/bin/build-sandbox-image.sh

## For Spark 3.1.1 bundle
export MLSQL_SPARK_VERSION=3.0
export SPARK_VERSION=3.1.1
export BYZER_LANG_VERSION=2.3.0-SNAPSHOT
export BYZER_NOTEBOOK_VERSION=1.0.2-SNAPSHOT
./dev/bin/build-sandbox-image.sh

On the other hand, we support specifying git tag to build image:

## Build with tag
export MLSQL_SPARK_VERSION=3.0
export SPARK_VERSION=3.1.1
export BYZER_LANG_VERSION=2.3.0-SNAPSHOT
export BYZER_NOTEBOOK_VERSION=1.0.2-SNAPSHOT
export MLSQL_TAG=v2.2.0
export BYZER_NOTEBOOK_TAG=v0.0.1-test
./dev/bin/build-sandbox-image.sh
```
4. Check image
```shell
docker images
REPOSITORY      TAG                    IMAGE ID       CREATED          SIZE
byzer-sandbox   3.1.1-latest           c24583e8fe47   34 minutes ago   2.61GB
```

## Pushing Image to Docker hub
```shell
export SPARK_VERSION=3.1.1
export BYZER_LANG_VERSION=2.2.1-SNAPSHOT
## Please enter username & password during execution
./dev/bin/push-image.sh <repo>
```

## Environment Variables
````shell
export SPARK_VERSION=<2.4.3 || 3.1.1>
export SPARK_HOME=/work/spark-${SPARK_VERSION}
export MLSQL_HOME=/home/deploy/kolo-lang
export BYZER_NOTEBOOK_HOME=/home/deploy/byzer-notebook
export PATH=$PATH:${MLSQL_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin
````

## Scripts
```shell
/home/deploy/start-sandbox.sh
$MLSQL_HOME/bin/start-local.sh
```

## Start service

You can start the sandbox service with the following command:

```
docker run -d --name sandbox-3.1.1-latest \
-p9002:9002 \
-p 9003:9003 \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root \
byzer/byzer-sandbox:3.1.1-latest
```

You can also use the script we provide to start the sandbox service:

```shell
sh -x dev/bin/run-sandbox-container.sh
```

## Directory Structure
```shell
|-- /work/
        |-- logs/  
        |-- users/
        |-- spark-${SPARK_VERSION}/
|-- /home/deploy/
        |-- README.md
        |-- byzer-lang/
            |-- bin/                          
            |-- conf/                         
            |-- libs/                         
        |-- byzer-notebook/                   
            |-- conf/                         
            |-- logs/                         
            |-- sample/    
```

## Installed software
- MySQL 8 Community Server
- OpenJDK 8
- Python 3.6
- PyJava 0.3.3
- Ray 1.3.0
- Pandas
- PyArrow