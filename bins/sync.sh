#!/bin/bash
# auto commit and push tools 
# add it to crontab
PWD=$(cd `dirname $0`; pwd)
SRC_DIR="$PWD/.."
cd $SRC_DIR
git pull
git add *
git commit -a -m "daily commit"
git push

