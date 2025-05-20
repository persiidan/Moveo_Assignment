#!/bin/bash
dnf update -y
dnf install -y docker
systemctl start docker
systemctl enable docker

docker pull idanpesi/moveo-nginx:latest
docker run -d -p 80:80 --name nginx idanpesi/moveo-nginx:latest