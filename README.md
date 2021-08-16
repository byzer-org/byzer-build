# mlsql-build

Project mlsql-build comes with tools to build
- MLSQL sandbox docker image
- [MLSQL Engine](https://github.com/allwefantasy/mlsql/) K8S image

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
