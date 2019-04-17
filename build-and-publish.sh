#!/bin/bash

elm-app build

# https://fx.navi.cc
rsync -av ./build/ root@fx.navi.cc:/var/www/html/

# https://phoenix.baden.work
# gh-pages -d build
