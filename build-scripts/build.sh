#!/bin/bash

TARGET_BUILD_TYPE=
TARGET_APP_VERSION=
TARGET_APP_TYPE=
TIZEN_COMMAND=
SECURITY_PROFILE="dev"

# Build for release.
function release_build
{
    npm install
    npm run build
    ${TIZEN_COMMAND} package -t wgt -s ${SECURITY_PROFILE} -- ./ -o .result/
}

# Build for development.
function dev_build
{
    npm install
    npm run dev   
}

function build
{
    if [ ${TARGET_BUILD_TYPE} != "dev" ] && [ ${TARGET_BUILD_TYPE} != "release" ]; then
        exit
    else
        if [ ${TARGET_BUILD_TYPE} = "dev" ]; then 
            dev_build
        elif [ ${TARGET_BUILD_TYPE} = "release" ]; then 
            if [ "${TARGET_APP_VERSION}" = "" ] || [ "${TARGET_APP_TYPE}" = "" ]; then
                exit
            else
                release_build
            fi    
        else 
            exit
        fi
    fi
}

function set_tizen_command
{
    OS=
    case "`uname -s`" in         
        MINGW32*) OS="WINDOWS";; 
        MINGW64*) OS="WINDOWS";; 
        CYGWIN*) OS="WINDOWS";; 
    esac 
    
    if [ "${OS}" = "WINDOWS" ] 
    then
        TIZEN_COMMAND="tizen.bat"
    fi

    echo "Checked ${OS} -> Set Tizen command to ${TIZEN_COMMAND}"
}


while getopts "b:v:t:h" opt
do
    case $opt in
        b) TARGET_BUILD_TYPE=${OPTARG};;
        v) TARGET_APP_VERSION=${OPTARG};;
        t) TARGET_APP_TYPE=${OPTARG};;
        h) print_usage ;;
        \?) print_usage ;;
    esac
done


echo "==========================================="
echo "TARGET_BUILD_TYPE : ${TARGET_BUILD_TYPE}"
echo "TARGET_APP_VERSION : ${TARGET_APP_VERSION}"
echo "TARGET_APP_TYPE : ${TARGET_APP_TYPE}"
echo "==========================================="

set_tizen_command
build
