#!/bin/bash

nvm use 14
npm run build-css || exit
elm-app build || exit

firebase deploy
