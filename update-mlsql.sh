#!/usr/bin/env bash

self=$(cd $(dirname $0)&& pwd)
cd ${self}

if [[ ! -d mlsql/.git ]]; then
    echo "cloning mlsql repo..."
    git clone https://github.com/allwefantasy/mlsql mlsql
else
    echo "update mlsql to latest..."
    cd mlsql
    git checkout master
    git pull -r origin master
    cd ..
fi