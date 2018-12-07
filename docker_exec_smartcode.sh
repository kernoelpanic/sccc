#!/bin/bash



CONTAINER_ID=$(docker ps | grep smartcode | cut -d" " -f1)

# use --user 0 to get a root shell
docker exec \
  --user 1000 \
  -it ${CONTAINER_ID} \
  /bin/bash
