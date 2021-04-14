#!/bin/bash

npm run build-css || exit
elm-app build || exit

firebase deploy

