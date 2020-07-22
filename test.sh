#!/bin/sh

rm -f without-buildkit with-buildkit

DOCKER_BUILDKIT=0 docker build -t without-buildkit .
DOCKER_BUILDKIT=1 docker build -t with-buildkit .

docker run without-buildkit > without-buildkit
docker run with-buildkit > with-buildkit

if diff -u without-buildkit with-buildkit; then
	echo "No difference between context with and without buildkit"
	exit 0
fi
echo "The build contexts differ"
