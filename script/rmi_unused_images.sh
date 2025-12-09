#!/bin/sh

RUNNING=$(docker compose ps --format '{{.Image}}' | paste -sd ' ' | sed -e 's/\s/ -e /g')
IMAGES=$(docker images --format '{{.Repository}}:{{.Tag}}' | grep tierbase)
if [ -n "${RUNNING}" ]; then
  IMAGES=$(echo ${IMAGES} | grep -v -e ${RUNNING})
fi
if [ -n "${IMAGES}" ]; then
  docker rmi ${IMAGES}
fi
