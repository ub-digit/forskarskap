#!/bin/bash

APP_DIR="forskarskap"
cd ../../
if [[ "${PWD##*/}" != "${APP_DIR}" ]]; then
   echo "The ../../ directory must be ${APP_DIR}"
   exit
fi
rm Dockerfile
rm entrypoint.sh
rm .dockerignore

