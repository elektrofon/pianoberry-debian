#!/bin/sh

cp config ./pi-gen/config

rm -Rf ./pi-gen/pianoberry
cp -r pianoberry ./pi-gen/pianoberry

cd ./pi-gen
./build-docker.sh
