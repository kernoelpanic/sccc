#!/bin/bash

if [ -z "${1}" ] && [ -z "${PORT+x}" ];
then 
	export PORT=8888
elif [ ! -z "${1}" ];
then
	export PORT="${1}"
fi

docker run \
  -p 127.0.0.1:${PORT}:8888 \
  --mount type=bind,source=$(pwd),target=/smartcode \
  --net smartnet \
  --hostname smartcode \
  --ip 172.18.0.3 \
  -it smartcode:latest
