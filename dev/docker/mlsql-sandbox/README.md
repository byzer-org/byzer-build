# MLSQL Sandbox 

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