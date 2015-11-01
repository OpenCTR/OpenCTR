#!/bin/sh

export BUILD_DIR="/home/travis/build/OpenCTR/OpenCTR/build"

printerror() {
    local FILENAME

    if [ -z "$1" ]
    then
        return
    elif [ ! -e "$1" ]
    then
        return
    else
        FILENAME=$(basename "${1}")
        TARGET=$(echo "${FILENAME}" | awk -F"-" '{print $1}')
        STAGE=$(echo ${FILENAME#${TARGET}-} | rev | cut -c 9- | rev)

        echo "  Error at ${TARGET} stage ${STAGE}:"
        cat "$1"

    fi
}


printerror "${BUILD_DIR}/projects/src/libctr-stamp/libctr-install-err.log"
printerror "${BUILD_DIR}/projects/src/libctr-stamp/libctr-build-err.log"
printerror "${BUILD_DIR}/projects/src/libctr-stamp/libctr-configure-err.log"
printerror "${BUILD_DIR}/projects/src/libctr-stamp/libctr-download-err.log"
printerror "${BUILD_DIR}/projects/src/libctr-stamp/libctru-install-err.log"
printerror "${BUILD_DIR}/projects/src/libctr-stamp/libctru-build-err.log"
printerror "${BUILD_DIR}/projects/src/libctr-stamp/libctru-configure-err.log"
printerror "${BUILD_DIR}/projects/src/libctr-stamp/libctru-download-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-install-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-build-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-install-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-build-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-configure-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-download-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-install-gcc-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-all-gcc-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-configure-err.log"
printerror "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-download-err.log"
printerror "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-install-err.log"
printerror "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-build-err.log"
printerror "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-configure-err.log"
printerror "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-download-err.log"
printerror "${BUILD_DIR}/tools/src/tools-stamp/tools-install-err.log"
printerror "${BUILD_DIR}/tools/src/tools-stamp/tools-build-err.log"
printerror "${BUILD_DIR}/tools/src/tools-stamp/tools-configure-err.log"
printerror "${BUILD_DIR}/tools/src/tools-stamp/tools-download-err.log"
