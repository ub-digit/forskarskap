#!/bin/bash

APP_DIR="forskarskap"
cd ../../
if [[ "${PWD##*/}" != "${APP_DIR}" ]]; then
   echo "The ../../ directory must be ${APP_DIR}"
   exit
fi
cp -a Dockerfile    docker/web/
cp -a entrypoint.sh docker/web/
cp -a .dockerignore docker/web/

