#!/bin/bash

docker run \
  -p 127.0.0.1:8888:8888 \
  --mount type=bind,source=$(pwd),target=/smartcode \
  --net smartnet \
  --hostname smartcode \
  --ip 172.18.0.3 \
  -it smartcode:latest
