#!/bin/bash
set -e
set -x

function abort()
{
	echo "$@"
	exit 1
}

function cleanup()
{
	echo " --> Stopping container"
	docker stop "$ID" >/dev/null
	docker rm "$ID" >/dev/null
}

PWD=$(pwd)

echo " --> Starting container"
if [[ "$HOST_NOT_ARM" = "1" ]]; then
	ID=$(docker run -d -v "$PWD/test:/test" "$NAME:$VERSION" /bin/bash -c 'while true; do echo "running"; sleep 5; done;')
else
	ID=$(docker run -d -v "$PWD/test:/test" "$NAME:$VERSION" /bin/bash -c 'while true; do echo "running"; sleep 5; done;')
fi
sleep 1

trap cleanup EXIT

echo " --> Logging into container and running tests"
docker exec "$ID" /test/test.sh
