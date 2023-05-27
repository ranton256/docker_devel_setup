# Docker Devel Setup

Local Docker setup for developing in Ubuntu


## Overview

This repo contains a Dockerfile and a couple scripts to build and use a Docker container suitable for local development.

It is setup for gcc, make, and git, but you can update the Dockerfile to add whatever other packages you would find useful.


In order to use this you will need to install Docker on your host machine.

## Docker

Install Docker desktop for MacOS, Windows, or Linux.

- [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)
- [Install Docker Desktop on Mac](https://docs.docker.com/desktop/install/mac-install/)
- [Install Docker Desktop on Linux](https://docs.docker.com/desktop/install/linux-install/)

Alternatively, you can [install Docker engine](https://docs.docker.com/engine/install/).

## Usage

Just run this command from the directory containing the files from this Git repository.
This will build the container image, and launch it with a bash shell as the primary process.

`./run_docker.sh`

Inside the docker container, you will be running Ubuntu.
At the time of this writing, the base Ubuntu image is version 22.04.2 LTS (Jammy Jellyfish)

The container will start as root, fix some permissions concerns with `fix_docker_user.sh` then 
you will be running as the user `coder` with the same UID as the host user you started the docker container from.

A shared volume will be setup in the host machine's directory under a subdirectory `ccc`,
which will be mounted at `/home/coder/ccc` inside the container.

This allows you to use your favorite editor on your host machine and build and run your code in a reproducable Linux container image.


## Example

```bash
% cat run_docker.sh 
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
  
  
% ./run_docker.sh 
[+] Building 0.1s (14/14) FINISHED                                                                                                                                                                     
 => [internal] load build definition from Dockerfile                                                                                                                                              0.0s
 => => transferring dockerfile: 37B                                                                                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                                                                                 0.0s
 => => transferring context: 2B                                                                                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/ubuntu:latest                                                                                                                                  0.0s
 => [1/9] FROM docker.io/library/ubuntu                                                                                                                                                           0.0s
 => [internal] load build context                                                                                                                                                                 0.0s
 => => transferring context: 1.07kB                                                                                                                                                               0.0s
 => CACHED [2/9] RUN apt-get update                                                                                                                                                               0.0s
 => CACHED [3/9] RUN apt-get install -y sudo                                                                                                                                                      0.0s
 => CACHED [4/9] RUN useradd -ms /bin/bash coder -p "$(openssl passwd -1 g0ldF!sh)"                                                                                                               0.0s
 => CACHED [5/9] RUN apt-get install -y make gcc git curl                                                                                                                                         0.0s
 => CACHED [6/9] RUN apt-get  install -y g++                                                                                                                                                      0.0s
 => CACHED [7/9] RUN apt-get  install -y g++ bison flex                                                                                                                                           0.0s
 => CACHED [8/9] WORKDIR /home/coder                                                                                                                                                              0.0s
 => [9/9] COPY fix_docker_user.sh /bin/fix_docker_user.sh                                                                                                                                         0.0s
 => exporting to image                                                                                                                                                                            0.0s
 => => exporting layers                                                                                                                                                                           0.0s
 => => writing image sha256:78c934ffa8e90430d2bce8e04ffa59ee4551d6155cd5b37b9072a90cd522b752                                                                                                      0.0s
 => => naming to docker.io/library/local-dev                                                                                                                                                      0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
coder@5200ddac444c:~$ whoami
coder
coder@5200ddac444c:~$ pwd
/home/coder
coder@5200ddac444c:~$ echo Hello > ccc/new_file
coder@5200ddac444c:~$ exit
exit
% cat ccc/new_file 
Hello
% 

```
