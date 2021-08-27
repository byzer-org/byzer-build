#!/usr/bin/env bash

home=$(cd $(dirname $0)/.. && pwd)
cd ${home}

if [[ ! -d console/.git ]]; then
    echo "cloning console repo..."
    git clone https://github.com/allwefantasy/mlsql-api-console console
else
    echo "update console to latest..."
    cd console
    git checkout master
    git pull -r origin master
    cd ..
fi