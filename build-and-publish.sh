#!/bin/bash

elm-app build


APP_ROOT="/opt/fx.navi.cc"

echo "Publish: fx.navi.cc"
ssh root@fx.navi.cc mkdir -p $APP_ROOT/www/
ssh root@fx.navi.cc mkdir -p $APP_ROOT/etc/
ssh root@fx.navi.cc mkdir -p $APP_ROOT/log/
rsync -av ./build/ root@fx.navi.cc:$APP_ROOT/www/
scp etc/fx.navi.cc.conf root@fx.navi.cc:$APP_ROOT/etc/

# https://fx.navi.cc
# rsync -av ./build/ root@fx.navi.cc:/var/www/html/

# https://phoenix.baden.work
# gh-pages -d build
