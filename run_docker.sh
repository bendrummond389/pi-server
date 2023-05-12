#!/bin/bash

CONTAINER_NAME="<your-container-name>"
IMAGE_NAME="<your-docker-username/your-image-name:version-tag>"
IMAGE_PATH="<path-to-your-image.tar>"

# Stop and remove the old container if it exists
docker stop $CONTAINER_NAME || true && docker rm $CONTAINER_NAME || true

# Remove the old image if it exists
OLD_IMAGE_ID=$(docker images -q $IMAGE_NAME)
if [ -n "$OLD_IMAGE_ID" ]; then
    docker rmi $OLD_IMAGE_ID
fi

# Load the new image
docker load -i $IMAGE_PATH

# Run the new container
docker run -p 3000:80 -d --name $CONTAINER_NAME $IMAGE_NAME
