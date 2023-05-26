#!/bin/sh

if [ ! -e ccc ]; then
    mkdir ccc
fi

docker build -t local-dev . || exit 37

docker run \
  -e HOST_UID="$(id -u)" \
  -e HOST_GID="$(id -g)" \
  --mount type=bind,source="$(pwd)"/ccc,target=/home/coder/ccc \
  -it local-dev /bin/bash
