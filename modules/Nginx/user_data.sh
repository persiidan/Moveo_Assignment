#!/bin/bash
dnf update -y
dnf install -y docker
systemctl start docker
systemctl enable docker

cat <<-EOD > Dockerfile
FROM nginx:alpine
RUN echo "yo this is nginx" > /usr/share/nginx/html/index.html
EOD

docker build -t webimg .
docker run -d -p 80:80 --name web webimg