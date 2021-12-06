# MLSQL Sandbox 

## Environment Variables
````shell
export SPARK_VERSION=<2.4.3 || 3.1.1>
export SPARK_HOME=/work/spark-${SPARK_VERSION}
export MLSQL_HOME=/home/deploy/kolo-lang
export BYZER_NOTEBOOK_HOME=/home/deploy/byzer-notebook
export PATH=$PATH:${MLSQL_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin
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