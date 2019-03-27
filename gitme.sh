#!/bin/bash

branch=xg

case $1 in
    "-b")
    branch=$2
    ;;
    "-h")
    echo "
            默认切换xg并合并master
            -h 帮助
        "
    exit 0
    ;;
esac

git checkout $branch
git checkout master
git pull
git checkout $branch
git merge master

