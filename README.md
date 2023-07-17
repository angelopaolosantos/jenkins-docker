# Jenkins on Docker #


### Installation ###
1. Create bridge network in Docker
```
docker network create jenkins
```

2. Build custom docker image from Dockerfile
```
docker build -t myjenkins-blueocean:2.401.2-1 .
```

3. Run custom docker image as container in Docker
```
docker run --name jenkins-blueocean --restart=on-failure --detach \
  --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.401.2-1
```
---
### Post Installation ###
Run command to get secret password to unlock Jenkins
```
sudo docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
```
---

### Docker Cloud Agents ###
Get local docker URI for setting up docker cloud agents

```
docker run --name docker-uri -d --restart=always -p 127.0.0.1:2376:2375 --network jenkins -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
docker inspect docker-uri | grep IPAddress
```

**Docker Host URI**
`tcp://<IPAddress>:2375`
<br>

---
References:
https://www.jenkins.io/doc/book/installing/docker/
https://devopscube.com/docker-containers-as-build-slaves-jenkins/
https://github.com/devopsjourney1/jenkins-101