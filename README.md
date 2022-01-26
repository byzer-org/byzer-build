# byzer-build

Project byzer-build comes with tools to build
- byzer sandbox docker image
- [byzer Engine](https://github.com/byzer-org/byzer-lang/) K8S image
- byzer app

## byzer Sandbox Docker Image
With byzer Sandbox docker image, users are able to take a quick glance into byzer stack.

### Pre-built image
Based on spark 2.4.3:
```
docker pull byzer/byzer-lang-k8s:2.4.3-2.2.0-SNAPSHOT
```

Based on spark 3.1.1:
```
docker pull byzer/byzer-lang-k8s:3.1.1-2.2.0-SNAPSHOT
```

### Environment Variables
```
export SPARK_VERSION=<2.4.3 || 3.1.1>
export BYZER_LANG_VERSION=2.2.0-SNAPSHOT
```

## Running sandbox

### Pre-built image

Based on spark 2.4.3:
```
docker pull byzer/byzer-sandbox:2.4.3-2.2.0-SNAPSHOT
```

Based on spark 3.1.1:
```
docker pull byzer/byzer-sandbox:3.1.1-2.2.0-SNAPSHOT
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
--name mlsql-sandbox-${SPARK_VERSION}-${BYZER_LANG_VERSION} \
byzer-sandbox:${SPARK_VERSION}-${BYZER_LANG_VERSION}
```

### Building Sandbox
[Click for details](./docs/sandbox.md)

## byzer Engine K8S Image

Pre-built image: 

```
docker pull byzer/byzer-lang-k8s:3.1.1-2.2.0-SNAPSHOT
```

### Building byzer Engine K8S Image
```shell
./dev/bin/build-spark3-image.sh
```

Please find a step-by-step guide on K8S deployment from [byzer-k8s](https://github.com/byzer-org/byzer-k8s)

## Byzer CLI
To install and run the CLI, please visit [CLI doc](https://docs.byzer.org/#/byzer-lang/zh-cn/installation/cli-installation) .
Tar ball naming convention is `byzer-lang-<os>-<byzer_spark_version>-<byzer_lang_version>.tar.gz`.

| Parameter           | Explanation                                                             |
|---------------------|-------------------------------------------------------------------------|
| byzer_lang_version  | The [Byzer Lang](https://github.com/byzer-org/byzer-lang/pulls) version |
| byzer_spark_version | 3.0 for Spark 3.1.1 2.4 for Spark 2.4.3                                 |
| os                  | linux darwin(mac) win                                                   |

To build the Byzer CLI
```shell
./dev/bin/app/build-byzer-cli-release.sh <byzer_spark_version> <byzer_lang_version> <os>
```
For instance, to build Byzer CLI for linux spark 3.1.1 byzer-lang 2.2.0, run
```shell
./dev/bin/app/build-byzer-cli-release.sh 3.0 2.2.0 linux
```

## Multi-container deployment

We provide scripts to start multiple microservices at once to facilitate us to build and start docker containers flexibly. Each service is deployed in an independent Ubuntu environment, which can isolate resources and environments.
