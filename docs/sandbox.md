# Byzer Sandbox

## Building Byzer Sandbox

Please change BYZER_LANG_VERSION & BYZER_NOTEBOOK_VERSION according to each project's pom.xml

```shell   
## For Spark 2.4.3 bundle
export SPARK_VERSION=2.4.3
export BYZER_LANG_VERSION=2.3.0-SNAPSHOT
export BYZER_NOTEBOOK_VERSION=1.0.2-SNAPSHOT
./dev/bin/build-sandbox-image.sh

## For Spark 3.1.1 bundle
export SPARK_VERSION=3.1.1
export BYZER_LANG_VERSION=2.3.0-SNAPSHOT
export BYZER_NOTEBOOK_VERSION=1.0.2-SNAPSHOT
./dev/bin/build-sandbox-image.sh

On the other hand, we support specifying git tag to build image:

## Build with tag
export SPARK_VERSION=3.1.1
export BYZER_LANG_VERSION=2.3.0-SNAPSHOT
export BYZER_NOTEBOOK_VERSION=1.0.2-SNAPSHOT
export BYZER_NOTEBOOK_TAG=v0.0.1-test
./dev/bin/build-sandbox-image.sh
```

If you'd like to skip building notebook and notebook exists in dev/lib/ , please `export SKIP_BUILDING_NOTEBOOK=true`

Check image
```shell
docker images
REPOSITORY      TAG                    IMAGE ID       CREATED          SIZE
byzer-sandbox   3.1.1-latest           c24583e8fe47   34 minutes ago   2.61GB
```

## Environment Variables
````shell
export JAVA_HOME=/work/openjdk-8u332
export SPARK_VERSION=<2.4.3 || 3.1.1>
export SPARK_HOME=/work/spark-${SPARK_VERSION}
export BYZER_LANG_HOME=/home/deploy/byzer-lang
export BYZER_NOTEBOOK_HOME=/home/deploy/byzer-notebook
export PATH=$PATH:${MLSQL_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin
````

## Directory Structure
```shell
|-- /work/
        |-- logs/  
        |-- users/
        |-- spark-${SPARK_VERSION}/
|-- /home/deploy/byzer-lang/_delta/
|-- /home/deploy/
        |-- README.md
        |-- byzer-lang/
            |-- bin/                          
            |-- conf/                         
            |-- libs/                         
            |-- main/                         
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
- Ray 1.8.0
- Pandas
- PyArrow