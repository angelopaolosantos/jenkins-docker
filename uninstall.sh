#!/bin/sh

# Check if docker is running.
while (! docker stats --no-stream ); do
  # Docker takes a few seconds to initialize
  echo "Waiting for Docker to launch...\n"
  sleep 1
done

docker rm jenkins-docker -v -f
docker rm jenkins-blueocean -v -f
docker rmi myjenkins-blueocean
docker volume rm jenkins-data
docker volume rm jenkins-docker-certs