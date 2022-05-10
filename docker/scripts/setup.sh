#!/bin/bash

APP_DIR="forskarskap"
cd ../../
if [[ "${PWD##*/}" != "${APP_DIR}" ]]; then
   echo "The ../../ directory must be ${APP_DIR}"
   exit
fi
cp -a docker/web/Dockerfile    .
cp -a docker/web/entrypoint.sh .
cp -a docker/web/.dockerignore .

