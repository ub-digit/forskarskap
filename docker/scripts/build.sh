#!/bin/bash

IMAGE_WEB=`grep IMAGE_WEB ../.env | cut -d = -f 2`
AFFIRMATIVE="yes"
cd ../../
echo "Do you want to build the \"${IMAGE_WEB}\" image ("${AFFIRMATIVE}"/no)? " | tr -d '\n'
read answer
if [[ $answer = "${AFFIRMATIVE}" ]]; then
  echo "Building ${IMAGE_WEB} ..."
  docker build -t ${IMAGE_WEB} .
else
  echo "No build executed."
fi

