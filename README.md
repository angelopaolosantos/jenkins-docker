# Jenkins on Docker
## Prerequisites
Minimum hardware requirements:
- 256 MB of RAM
- 1 GB of drive space (although 10 GB is a recommended minimum if running Jenkins as a Docker container)
- Docker cli must be installed and running

## Installation
1. Make the install script executable `chmod u+x install.sh`
2. Run shell script `./install.sh`
3. Copy paste Jenkins initial password in terminal on the Jenkins unlock page
4. Process with the setup wizard

## Clean up
1. Make the uninstall script executable `chmod u+x uninstall.sh`
2. Run shell script `./uninstall.sh`
---
References:
https://www.jenkins.io/doc/book/installing/docker/
https://www.jenkins.io/doc/book/pipeline/docker/
https://devopscube.com/docker-containers-as-build-slaves-jenkins/
https://github.com/devopsjourney1/jenkins-101
