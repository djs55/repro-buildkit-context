#!/bin/sh

DOCKER_BUILDKIT=0 docker build -t without-buildkit .
DOCKER_BUILDKIT=1 docker build -t with-buildkit .

docker run without-buildkit > without-buildkit
docker run with-buildkit > with-buildkit

diff -u without-buildkit with-buildkit
