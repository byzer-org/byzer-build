# Byzer-build

Project byzer-build comes with tools to build
- Byzer sandbox docker image
- Byzer lang container
- [Byzer-lang](https://github.com/byzer-org/byzer-lang/) K8S image
- Byzer CLI

## Byzer Sandbox Docker Image
With Byzer Sandbox docker image, users are able to take a quick glance into Byzer stack.
Based on spark 2.4.3:
```
docker run -d --name sandbox -p 9002:9002 -p 9003:9003 -e MYSQL_ROOT_PASSWORD=root byzer/byzer-sandbox:2.4.3-latest
```

Based on spark 3.1.1:
```
docker run -d --name sandbox -p 9002:9002 -p 9003:9003 -e MYSQL_ROOT_PASSWORD=root byzer/byzer-sandbox:3.1.1-latest

```

### Building Sandbox
[Click for details](./docs/sandbox.md)

## Byzer-lang Container
`docker run -d --name byzer-lang -e DRIVER_MEMORY=8g -e MASTER=local[*] -p9003:9003 byzer/byzer-lang:3.1.1-latest`
This command launches byzre-lang container with
- heap size of 8GB
- byzer-lang on local mode
- exposes container's 9003 port 

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

