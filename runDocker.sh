#!/bin/bash

MOUNT_PATH=$(pwd)
IMAGE_NAME="birddock/computer-architecture"
CONTAINER_NAME="computer-architecture"

CONTAINER_ID=$(docker ps -q -f name=$CONTAINER_NAME)

# remove existing container
if [[ $1 == *"r"* ]] && [[ ! -z $CONTAINER_ID ]]; then
  docker rm -vf $CONTAINER_ID
  CONTAINER_ID=""
fi

if [[ -z $CONTAINER_ID ]]; then
  docker start $CONTAINER_ID
else
  docker run -d \
    -p 5900:5900 \
	  -v $MOUNT_PATH/dosbox:/dosbox \
	  -v $MOUNT_PATH/verilog:/verilog \
	  --name $CONTAINER_NAME \
    $IMAGE_NAME
fi
