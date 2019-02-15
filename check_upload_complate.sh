#!/bin/bash


CHECK_DIRS="/data/home/"
CHECK_SLEEP=10
CHECK_DAYS=3
LOG=./.check.log
NOW="echo [\`$anynowtime\`][PID:$$]"
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

function log() {
    MSG="$*"
    echo "`eval $NOW` :[$MSG] " >> $LOG
}


function fileUploadDone() {
    local check_file=$1
    if [ ! -f $check_file ];then
        log "file $check_file is not exists!"
        return 1
    fi

    # filter file if exists $.ok file
    if [ -f ${check_file}.OK ];then
        log "file ${check_file}.OK is exists! no need to check this file[${check_file}], continue..."
        return 0
    fi

    # check file size
    local check_befor=$(du -s ${check_file} | awk '{print $1}')
    sleep $CHECK_SLEEP
    local check_after=$(du -s ${check_file} | awk '{print $1}')

    if [ "${check_befor}" != "${check_after}" ];then
        log "the file[${check_file}] size check_befor:${check_befor} != check_after:${check_after} ,file is uploading, continue..."
        return 1 
    fi

    #3. check file md5
    local check_file_md5=$(md5sum $check_file | awk '{print $1}')
    local md5file_md5=$(cat ${check_file}.MD5  2>/dev/null | awk '{print $1}')
    if [ -z "${md5file_md5}" ];then
        log "missing md5file_md5: ${check_file}.MD5"
        return 1

    fi

    if [ "${check_file_md5}" != "${md5file_md5}" ];then
        log "${check_file}.MD5:${md5file_md5} != ${check_file}:${check_file_md5}, md5 is not equal..............."
        return 1
    else
        log "md5 is equal: ${check_file} ${check_file_md5}..............."
        touch ${check_file}.OK
    fi



}

function main() {
    for d in $CHECK_DIRS;do
        #1. get fiels to check  /3days ago files
        ALL_CHECK_FILES=$(find $d -ctime -${CHECK_DAYS} -type f -print | grep -ivE  '(OK|MD5)$')
        if [ -z "${ALL_CHECK_FILES}" ];then
            log "no files to check!"
            exit 0
        fi
        for EACH_FILE in ${ALL_CHECK_FILES};do
            fileUploadDone $EACH_FILE
       done
    done


}


##### MAIN ####
main
