cd ../docker/compose-resource/byzer-lang/ray
docker build -t  byzer/ray-test .

docker run -d  --privileged \
-p 18265:8265 \
-p 10009:10001 \
--name ray-test2 \
byzer/ray-test