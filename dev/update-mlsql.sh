#!/usr/bin/env bash

home=$(cd $(dirname $0)/.. && pwd)
cd ${home}

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