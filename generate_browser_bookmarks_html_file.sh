# !/bin/bash
# -----------------------------------------------------
# 生成HTML格式浏览器书签文件
# 暂时只支持二级目录，其它未测试
# https://github.com/zhengxiaopeng/android-dev-bookmarks/blob/master/generate_browser_bookmarks_html_file.sh
# 
# Rocko(rocko.xyz)
# -----------------------------------------------------

DEBUG=true
OUTPUT_FILE_NAME='android-dev-bookmarks.html' # 最终生成的文件
FILE_LIST=`ls -d */|sed 's|[/]||g'` # 所有分类文件夹
let BASE_TITLE_FLAG_CHAR_NUM=2

log() {
    if [[ ${DEBUG} == true ]]; then
        echo ${*}
    fi
}


appendToFile() { # 给文件添加一行， 取全部内容作为参数
    echo ${*} >> ${OUTPUT_FILE_NAME} 
}

generate() {
    log '开始生成...'
    # 头
    appendToFile '<!-- 通过浏览器书签管理器将此HTML文件导入书签 -->'
    appendToFile '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">'
    appendToFile '<H1>android-dev-bookmarks</H1>'
    appendToFile '<DL>'

    generateContent

    # 尾
    appendToFile '</DL>'
    
    log '生成完毕...'
}

generateContent() {
    log '开始遍历生成内容...'

    # :-)
    appendToFile '<DT><A HREF="http://adb.rocko.xyz/">ADB</A>'
    
    for file in ${FILE_LIST}
    do  
        log '##################################################################################################'
        log '## 当前分类文件夹 >>> '${file}
        log '##################################################################################################'

        # 每个文件夹分类都新建一级<DT>
        appendToFile '<DT><H3>'${file}'</H3>'
        appendToFile '<DL>'

        isReadingSiteLine=false
        let titleNum=0
        let currentTitleFlagNum=${BASE_TITLE_FLAG_CHAR_NUM}
        shouldAppendTitleTail=false
        while read line # 读出每一行处理
        do ## TODO 多级标题时的处理
              line=`echo ${line} | tr -d '\r' | tr -d '\n'`   # 某些会带有这特殊符号导致换行，去掉。。。  WTF
              if [[ ${line} == \#* ]]; then # 每一Markdown标题即为一分类
                  titleFlagChar=${line%%' '*} # 标题空格截取
                  # echo ${line#*' '} # ‘#’后的标题文字
                  appendToFile '<DT><H3>'${line#*' '}'</H3>'
                  appendToFile '<DL>'
              
              elif [[ ${line} == \[* ]]; then         
                  # log '网址：'${line}
                  site_name=${line#*[}
                  site_name=${site_name%%]*}
                  
                  site_href=${line#*(}
                  site_href=${site_href%)*}

                  # log $site_name $site_href
                  appendToFile '<DT><A HREF="'${site_href}'">'${site_name}'</A>'  
              elif [[  ${line} == '.' ]]; then
                  appendToFile '</DL>'
              elif [[  ${line} == '..' ]]; then
                  appendToFile '</DL>'
                  appendToFile '</DL>'
              #else
              fi

        done < ${file}"/README.md" # 每一文件夹分类里的README具体书签内容
        appendToFile '</DL>'
    done 
}


rm -f ${OUTPUT_FILE_NAME}
touch ${OUTPUT_FILE_NAME}
generate