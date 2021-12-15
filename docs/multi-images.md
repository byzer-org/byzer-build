## Kolo Multi-images
Currently we will deploy these 3 containers: mysql:8.0-20.04_beta, kolo-lang, byzer-notebook.

### Pre-built image

Based on spark 2.4.3:
```
docker pull allwefantasy/kolo-lang:2.4.3-2.2.0
docker pull allwefantasy/mysql:8.0-20.04_beta
docker pull allwefantasy/byzer-notebook:1.0.0
```

Based on spark 3.1.1:
```
docker pull allwefantasy/kolo-lang:3.1.1-2.2.0
docker pull allwefantasy/mysql:8.0-20.04_beta
docker pull allwefantasy/byzer-notebook:1.0.0
```

### parameter settings

```
export MYSQL_ROOT_PASSWORD=root
export MYSQL_PORT=3306
export KOLO_LANG_PORT=9003
export BYZER_NOTEBOOK_PORT=9002
export SPARK_VERSION=3.1.1
export KOLO_LANG_VERSION=2.2.0-SNAPSHOT
export BYZER_NOTEBOOK_VERSION=0.0.1-SNAPSHOT
```

All the above parameters have default values, which are shown in the above parameters.

### Build images (Usage 1)

```
sh -x dev/bin/build-images.sh
```

### Build images with tag (Usage 2)

```
# Set startup parameters
export KOLO_LANG_VERSION=${KOLO_LANG_VERSION:-2.2.0}
export MLSQL_VERSION=${MLSQL_VERSION:-2.2.0}
export BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION:-1.0.0}
# Build image by specifying branch
export BYZER_NOTEBOOK_BRANCH=${BYZER_NOTEBOOK_BRANCH:-release-1.0.0}
export KOLO_LANG_BRANCH="${KOLO_LANG_BRANCH:-}"
# Build image by specifying tag
export BYZER_NOTEBOOK_TAG="${BYZER_NOTEBOOK_TAG:-}"
export MLSQL_TAG=${MLSQL_TAG:-v2.2.0}

sh -x dev/bin/build-images.sh
```

### Start multiple containers

```
sh -x dev/bin/docker-compose-up.sh
```

### How to user

1. Visit the byzer homepage, the url is: localhost:9002

2. The user name and password are: admin/admin

3. Experience byzer running tasks