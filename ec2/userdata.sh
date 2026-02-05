#!/bin/bash
dnf update -y
dnf install -y docker
systemctl start docker
systemctl enable docker

sleep 30

# Run Strapi
docker run -d \
  --name strapi \
  -p 1337:1337 \
  -e HOST=0.0.0.0 \
  -e PORT=1337 \
  strapi/strapi



