# mlsql-build

Project mlsql-build comes with tools to build
- MLSQL sandbox docker image
- [MLSQL Engine](https://github.com/allwefantasy/mlsql/) K8S image
- MLSQL app

## MLSQL Sandbox Docker Image
With MLSQL Sandbox docker image, users are able to take a quick glance into MLSQL stack.
### Running sandbox
```shell
docker run -d \
-p 3306:3306 \
-p 9002:9002 \
-e MYSQL_ROOT_PASSWORD=mlsql \
--name mlsql-sandbox-2.4.3-2.1.0-SNAPSHOT \
techmlsql/mlsql-sandbox:2.4.3-2.1.0-SNAPSHOT
```
### [Building Sandbox](./docs/sandbox.md)

## MLSQL Engine K8S Image
Pre-built image: 
```
https://hub.docker.com/repository/docker/chncaesar/mlsql-engine-k8s
```
### Building MLSQL Engine K8S Image
```shell
cd dev/docker
./engine/build-spark3-image.sh
```

Please find a step-by-step guide on K8S deployment from [mlsql-deploy](https://github.com/allwefantasy/mlsql-deploy)

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
tar -xf mlsql-app_2.4-2.1.0-SNAPSHOT.tar.gz 
mlsql-app_2.4-2.1.0-SNAPSHOT/bin/start-mlsql-app.sh

## Built with Spark 3.1.1
tar -xf mlsql-app_2.4-2.1.0-SNAPSHOT.tar.gz 
mlsql-app_2.4-2.1.0-SNAPSHOT/bin/start-mlsql-app.sh

```