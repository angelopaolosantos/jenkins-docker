#!/bin/sh

# Check if docker is running.
while (! docker stats --no-stream ); do
  # Docker takes a few seconds to initialize
  echo "Waiting for Docker to launch...\n"
  sleep 1
done

# Create Docker in Docker (DIND) container. Jenkins will connect this docker node and create container build agents in it. 
echo "creating jenkins-docker...\n"
if [ ! "$(docker ps -a -q -f name=^jenkins-docker$)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=^jenkins-docker$)" ]; then
        # cleanup
        docker rm jenkins-docker
    fi
    # run your container
    if ! docker run --name jenkins-docker --rm --detach \
      --privileged --network jenkins --network-alias docker \
      --env DOCKER_TLS_CERTDIR=/certs \
      --volume jenkins-docker-certs:/certs/client \
      --volume jenkins-data:/var/jenkins_home \
      --publish 2376:2376 \
      docker:dind --storage-driver overlay2; then
      
      echo "Failed to run jenkins-docker container...\n"
      exit 1
    fi

    echo "jenkins-docker container now running...\n"
else
  echo "jenkins-docker already running...\n"
fi

# Build Jenkins image with Docker cli and plugins installed.
echo "building myjenkins-blueocean docker image...\n"
docker build -t myjenkins-blueocean .

# Create Jenkins container 
echo "creating jenkins-blueocean...\n"
if [ ! "$(docker ps -a -q -f name=^jenkins-blueocean$)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=^jenkins-blueocean$)" ]; then
        # cleanup
        docker rm jenkins-docker
    fi
    # run your container
    if ! docker run --name jenkins-blueocean --restart=on-failure --detach \
      --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
      --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
      --publish 8080:8080 --publish 50000:50000 \
      --volume jenkins-data:/var/jenkins_home \
      --volume jenkins-docker-certs:/certs/client:ro \
      myjenkins-blueocean; then
      
      echo "Failed to run jenkins-blueocean container...\n"
      exit 1
    fi

    echo "jenkins-blueocean container now running..."

else
  echo "jenkins-blueocean already running...\n"
fi

sensible-browser http://localhost:8080/

# Get Jenkins initial admin password
echo "Jenkins initial password: "
docker exec jenkins-blueocean sh -c 'cat /var/jenkins_home/secrets/initialAdminPassword; exit $?' && echo "Please copy the password and paste it in the unlock jenkins page." || echo "Jenkins already unlocked. Initial password was deleted."