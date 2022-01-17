set -u
set -e
set -o pipefail

cd ../..
export STEP_01_BUILD_SANDBOX_IMAGE=${STEP_01_BUILD_SANDBOX_IMAGE:-true}
export STEP_02_BUILD_K8S_IMAGE=${STEP_02_BUILD_K8S_IMAGE:-false}
export STEP_03_BUILD_MULTI_IMAGE=${STEP_03_BUILD_MULTI_IMAGE:-true}
export SKIP_PUSH_MYSQL_IMAGE=${SKIP_PUSH_MYSQL_IMAGE:-true}
### Step1 构建 Sandbox 镜像
if [[ "${STEP_01_BUILD_SANDBOX_IMAGE}" == "true" ]]; then
  echo "step 1:start to build Sandbox image..."
  dev/bin/build-sandbox-image.sh
  echo "step 1:build Sandbox image successed!"


  echo "step 1:start to push images..."

  echo "=============== push SANDBOX Image ================"
  docker push byzer/byzer-sandbox:${SPARK_VERSION}-${MLSQL_VERSION}
  docker tag byzer/byzer-sandbox:${SPARK_VERSION}-${MLSQL_VERSION} byzer/byzer-sandbox:${SPARK_VERSION}-latest
  docker push byzer/byzer-sandbox:${SPARK_VERSION}-latest
fi



### Step2 构建 K8S 镜像

if [[ "${STEP_02_BUILD_K8S_IMAGE}" == "true" ]]; then
	echo "step 2:start to build K8S image..."
  dev/bin/build-spark3-image.sh
  echo "step 2:build K8S image successed!"

  echo "step 2:start to push images..."
  if [[ "${STEP_02_BUILD_K8S_IMAGE}" == "true" ]]; then
  	echo "=============== push k8s Image ================"

      docker push byzer/byzer-lang-k8s:${SPARK_VERSION}-${MLSQL_VERSION}
      docker tag byzer/byzer-lang-k8s:${SPARK_VERSION}-${MLSQL_VERSION} byzer/byzer-lang-k8s:${SPARK_VERSION}-latest
      docker push byzer/byzer-lang-k8s:${SPARK_VERSION}-latest
  fi
fi




### Step3 构建 MULTI 镜像
if [[ "${STEP_03_BUILD_MULTI_IMAGE}" == "true" ]]; then
  # 删除老版本
  #sudo rm -rf /usr/bin/docker-compose /usr/local/bin/docker-compose
  # 下载1.25.0 docker compose
  #curl -L https://get.daocloud.io/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  # 添加可执行权限
  #chmod a+rx /usr/local/bin/docker-compose
  #ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  alias docker-compose="sudo /usr/local/bin/docker-compose"
  echo "step 3:start to build MULTI image..."
  sh -x dev/bin/build-images.sh
  echo "step 3:build MULTI image successed!"
  echo "step 3:start to push images..."

  if [[ "${STEP_03_BUILD_MULTI_IMAGE}" == "true" ]]; then
    echo "=============== push multi Image ================"

      docker push byzer/byzer-notebook:${BYZER_NOTEBOOK_VERSION}
      docker tag byzer/byzer-notebook:${BYZER_NOTEBOOK_VERSION} byzer/byzer-notebook:latest
      docker push byzer/byzer-notebook:latest

    docker push byzer/byzer-lang:${SPARK_VERSION}-${MLSQL_VERSION}
      docker tag byzer/byzer-lang:${SPARK_VERSION}-${MLSQL_VERSION} byzer/byzer-lang:${SPARK_VERSION}-latest
      docker push byzer/byzer-lang:${SPARK_VERSION}-latest

      if [[ "${SKIP_PUSH_MYSQL_IMAGE}" == "false" ]]; then

      docker push byzer/mysql:8.0-20.04_beta

      fi
  fi
fi
