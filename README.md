# Byzer-build

Project byzer-build comes with tools to build
- Byzer sandbox docker image
- Byzer lang container
- Byzer-lang K8S image
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

## Byzer-lang K8S image

The image is built on Ubuntu 20.04, and packaged with
- OpenJDK 14
- Spark-3.1.1-bin-hadoop3.2
- Byzer-lang
- Byzer-lang extensions: Shell, Excel, MLLib, Assert
- MiniConda 3
- Python 3.6 Ray 1.8.0 pandas 1.0.5 seaborn sklearn keras tensorflow

An example to build the image

```shell
export BYZER_LANG_VERSION=2.3.0-SNAPSHOT
export SPARK_VERSION=3.1.1
## Run the script on dev directory, or it fails
cd dev
./bin/build-byzer-lang-k8s-azure-image.sh
```

**Directory structure**

```text
/work
├── jdk-14                        
├── logs
├── spark-3.1.1-bin-hadoop3.2
└── user

/home/deploy
├── byzer-lang
├── entrypoint.sh
├── logs
└── spark-warehouse

/opt/conda
├── LICENSE.txt
├── bin
├── compiler_compat
├── conda-meta
├── condabin
├── envs
├── etc
├── include
├── lib
├── [Apr 23 09:29]  pkgs
├── share
├── shell
├── ssl
├── x86_64-conda-linux-gnu
└── x86_64-conda_cos6-linux-gnu

```

## Byzer all-in-one
To install and run the all-in-one, please visit [all-in-one doc](https://docs.byzer.org/#/byzer-lang/zh-cn/installation/server/byzer-all-in-one-deployment) .
Tar ball naming convention is `byzer-lang-all-in-one-<os>-amd64-<byzer_spark_version>-<byzer_lang_version>.tar.gz`.

| Parameter           | Explanation                                                             |
|---------------------|-------------------------------------------------------------------------|
| byzer_lang_version  | The [Byzer Lang](https://github.com/byzer-org/byzer-lang/pulls) version |
| byzer_spark_version | 3.0 for Spark 3.1.1 2.4 for Spark 2.4.3                                 |
| os                  | linux darwin(mac) win                                                   |

To build the Byzer all-in-one
```shell
export JUICEFS_VERSION=0.17.5
export SPARK_VERSION=3.1.1
export BYZER_LANG_VERSION=2.3.0-SNAPSHOT
export OS=linux
# darwin for MacOS, win for Windows
./dev/bin/app/build-byzer-cli-release.sh
```

## Multi-container deployment

We provide scripts to start multiple microservices at once to facilitate us to build and start docker containers flexibly. Each service is deployed in an independent Ubuntu environment, which can isolate resources and environments.

