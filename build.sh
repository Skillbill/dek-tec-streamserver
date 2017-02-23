#!/bin/bash
set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"

rm -rf build
mkdir build
cd build
tar xf ../LinuxSDK.tar.gz
cd LinuxSDK/Drivers/Dta/Source/Linux; make
cp Dta.ko ../../../../../../ 
cd ../../../../../../
docker build . -t stremserver
