#!/bin/bash

set -e
cd /code

if [ -d "$1" ]; then
    time "./$1/run.awk"
fi
