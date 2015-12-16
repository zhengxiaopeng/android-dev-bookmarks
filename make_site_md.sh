#!/bin/bash
#-----------------------------------------------------
# 把目录下所有 README.md 内容转换为 page 格式内容 
#
# https://github.com/zhengxiaopeng/android-dev-bookmarks/blob/master/make_site_md.sh
# 
# Rocko(rocko.xyz)
#-----------------------------------------------------

fileList=`ls -d */|sed 's|[/]||g'` 
output=".output/"
rm -rf ${output}
mkdir ${output}

for file in ${fileList}
do  
    echo ${file}
    mkdir ${output}${file} 
    cp ${file}"/README.md" ${output}${file}"/index.md"
done 
