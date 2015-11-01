#!/bin/sh

export SOURCE_DIR=${PWD}
export BUILD_DIR=${SOURCE_DIR}/build

CMAKE=$(which cmake)
if [ -z "${CMAKE}" ]
then
    echo "CMake is NOT installed"
    exit 1
fi

run() {
    local CMD
    local ARGS
    
}