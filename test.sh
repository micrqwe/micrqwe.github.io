#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TIME="date +%Y-%m-%d.%H:%M:%S"
# ////////////////////////////////////// aliyun
cd ../micrqwe
pwd
rm -rf *
pwd
cd ../micrqwe.github.io
pwd
hexo deploy
echo "zhixing deploy"
cd public
echo "sfdsf"
cp -r  * ../../micrqwe/
echo "shanchuwenjian"
cd ../../micrqwe
pwd
git add .
git commit -m "`$TIME`自动打包"
git push
cd ../micrqwe.github.io
git add .
git commit -m "`$TIME`自动打包"
git push