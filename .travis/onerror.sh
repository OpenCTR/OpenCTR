#!/bin/sh

LOGPRINT=0

print() {
    if [ -z "$1" ]
    then
        return
    elif [ ! -e "$1" ]
    then
        return
    else
        if [ ${LOGPRINT} -eq 0 ]
        then
            cat "$1"
            LOGPRINT=1
        fi
    fi
}

print "${BUILD_DIR}/projects/src/libctr-stamp/libctr-install-err.log"
print "${BUILD_DIR}/projects/src/libctr-stamp/libctr-build-err.log"
print "${BUILD_DIR}/projects/src/libctr-stamp/libctr-configure-err.log"
print "${BUILD_DIR}/projects/src/libctr-stamp/libctr-download-err.log"
print "${BUILD_DIR}/projects/src/libctr-stamp/libctru-install-err.log"
print "${BUILD_DIR}/projects/src/libctr-stamp/libctru-build-err.log"
print "${BUILD_DIR}/projects/src/libctr-stamp/libctru-configure-err.log"
print "${BUILD_DIR}/projects/src/libctr-stamp/libctru-download-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-install-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-build-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-install-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-build-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-configure-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-download-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-install-gcc-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-all-gcc-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-configure-err.log"
print "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-download-err.log"
print "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-install-err.log"
print "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-build-err.log"
print "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-configure-err.log"
print "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-download-err.log"
print "${BUILD_DIR}/tools/src/tools-stamp/tools-install-err.log"
print "${BUILD_DIR}/tools/src/tools-stamp/tools-build-err.log"
print "${BUILD_DIR}/tools/src/tools-stamp/tools-configure-err.log"
print "${BUILD_DIR}/tools/src/tools-stamp/tools-download-err.log"
