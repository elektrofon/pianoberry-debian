#!/bin/sh

cp config ./pi-gen/config

rm -Rf ./pi-gen/pianoberry
cp -r pianoberry ./pi-gen/pianoberry

touch ./pigen/stage2/SKIP_IMAGES

cd ./pi-gen
./build-docker.sh
