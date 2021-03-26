#!/bin/bash

npm run build-css
elm-app build

firebase deploy

