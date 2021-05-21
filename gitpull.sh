#!/bin/bash 
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TIME="date +%Y-%m-%d.%H:%M:%S"
# ////////////////////////////////////// aliyun
cd ../micrqwe
rm -rf *
cd ../micrqwe.github.io
hexo clean
hexo deploy
cd public
cp -r  * ../../micrqwe/
cd ../../micrqwe
git add .
git commit -m "`$TIME`自动打包"
git push
cd ../micrqwe.github.io
git add .
git commit -m "`$TIME`自动打包"
git push
git checkout master
cp -rf ../micrqwe/* .
git add .
git commit -m "`$TIME`自动打包"
git push -f
git checkout hexo-master-build