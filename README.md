# mlsql-build

Project mlsql-build comes with tools to build
- MLSQL sandbox docker image
- [MLSQL Engine](https://github.com/byzer-org/kolo-lang/) K8S image
- MLSQL app

## MLSQL Sandbox Docker Image
With MLSQL Sandbox docker image, users are able to take a quick glance into MLSQL stack.

### Pre-built image
Based on spark 2.4.3:
```
docker pull allwefantasy/mlsql-engine:2.4-2.2.0
```

Based on spark 3.1.1:
```
docker pull allwefantasy/mlsql-engine:3.0-2.2.0
```

### Environment Variables
```
export SPARK_VERSION=<2.4.3 || 3.1.1>
export MLSQL_VERSION=2.2.0-SNAPSHOT
```

## Running sandbox

### Pre-built image

Based on spark 2.4.3:
```
docker pull allwefantasy/mlsql-sandbox:2.4.3-2.2.0
```

Based on spark 3.1.1:
```
docker pull allwefantasy/mlsql-sandbox:3.1.1-2.2.0
```

```shell
sh ./dev/bin/run-sandbox-container.sh
```

We support specifying the mysql root password. For example, if the password is `root`, please pass it to the script as a parameter:
```shell
sh ./dev/bin/run-sandbox-container.sh root
```

It uses this command to deploy the container internally, as follows:

```
docker run -d \
-p 3306:3306 \
-p 9002:9002 \
-p 9003:9003 \
-e MYSQL_ROOT_HOST=% \
-e MYSQL_ROOT_PASSWORD="${MYSQL_PASSWORD}" \
--name mlsql-sandbox-${SPARK_VERSION}-${MLSQL_VERSION} \
mlsql-sandbox:${SPARK_VERSION}-${MLSQL_VERSION}
```

### Building Sandbox
[Click for details](./docs/sandbox.md)

## MLSQL Engine K8S Image

Pre-built image: 

```
docker pull allwefantasy/mlsql-engine:3.0-2.2.0
```

### Building MLSQL Engine K8S Image
```shell
./dev/bin/build-spark3-image.sh
```

Please find a step-by-step guide on K8S deployment from [kolo-k8s](https://github.com/byzer-org/kolo-k8s)

## MLSQL App
The mlsql app is pre-built with its dependencies and runs as a local process. 
JRE8+ is required to run this app. 

### Building MLSQL App
#### Building with Spark 3.1.1
Please download and put the following packages in dev/docker/mlsql-sandbox/lib
- nlp-lang-1.7.8.jar
- ansj_seg-5.1.6.jar
- juicefs-hadoop-0.15.2-linux-amd64.jar
- mlsql-assert-3.0_2.12.jar
- mlsql-excel-3.0_2.12.jar
- spark-3.1.1-bin-hadoop3.2.tgz

Run the command to build
```shell
./dev/bin/app/build-mlsql-app.sh 3.1.1
```
#### Building with Spark 2.4.3
- nlp-lang-1.7.8.jar
- ansj_seg-5.1.6.jar
- juicefs-hadoop-0.15.2-linux-amd64.jar
- mlsql-assert-2.4_2.11.jar
- mlsql-excel-2.4_2.11.jar
- spark-2.4.3-bin-hadoop2.7.tgz

Run the command to build 
```
./dev/bin/app/build-mlsql-app.sh 2.4.3
```

### Running MLSQL App
```shell 
## Built with Spark 2.4.3
tar -xf mlsql-app_2.4-2.1.0-darwin-amd64.tar.gz
./mlsql-app_2.4-2.1.0-darwin-amd64/bin/start-mlsql-app.sh
```

## Multi-container deployment

We provide scripts to start multiple microservices at once to facilitate us to build and start docker containers flexibly. Each service is deployed in an independent Ubuntu environment, which can isolate resources and environments.
