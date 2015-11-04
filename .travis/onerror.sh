#!/bin/sh

export BUILD_DIR="/home/travis/build/OpenCTR/OpenCTR/build"
export TARBALL_DIR="/home/travis/build/OpenCTR/OpenCTR/openctr-logs"
export TARBALL_NAME="openctr-logs-${TRAVIS_JOB_NUMBER}"

LOGPRINT=0

copyfile() {
    local FILENAME

    if [ -z "$1" ]
    then
        return
    elif [ ! -e "$1" ]
    then
        return
    else
        FILENAME=$(basename "$1")

        if [ ! -d "${TARBALL_DIR}" ]
        then
            mkdir -p "${TARBALL_DIR}"
            if [ $? -ne 0 ]
            then
                echo "mkdir error"
                exit 1
            fi
        fi

        if [ ${LOGPRINT} -eq 0 ]
        then
            cat "$1"
            LOGPRINT=1
        fi

        cp "$1" "${TARBALL_DIR}/${FILENAME}"
    fi
}

copyfile "${BUILD_DIR}/projects/src/libctr-stamp/libctr-install-err.log"
copyfile "${BUILD_DIR}/projects/src/libctr-stamp/libctr-build-err.log"
copyfile "${BUILD_DIR}/projects/src/libctr-stamp/libctr-configure-err.log"
copyfile "${BUILD_DIR}/projects/src/libctr-stamp/libctr-download-err.log"
copyfile "${BUILD_DIR}/projects/src/libctr-stamp/libctru-install-err.log"
copyfile "${BUILD_DIR}/projects/src/libctr-stamp/libctru-build-err.log"
copyfile "${BUILD_DIR}/projects/src/libctr-stamp/libctru-configure-err.log"
copyfile "${BUILD_DIR}/projects/src/libctr-stamp/libctru-download-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-install-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-build-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-install-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-build-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-configure-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/newlib-stamp/newlib-download-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-install-gcc-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-all-gcc-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-configure-err.log"
copyfile "${BUILD_DIR}/toolchain/gcc/src/gcc-stamp/gcc-download-err.log"
copyfile "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-install-err.log"
copyfile "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-build-err.log"
copyfile "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-configure-err.log"
copyfile "${BUILD_DIR}/toolchain/binutils/src/binutils-stamp/binutils-download-err.log"
copyfile "${BUILD_DIR}/tools/src/tools-stamp/tools-install-err.log"
copyfile "${BUILD_DIR}/tools/src/tools-stamp/tools-build-err.log"
copyfile "${BUILD_DIR}/tools/src/tools-stamp/tools-configure-err.log"
copyfile "${BUILD_DIR}/tools/src/tools-stamp/tools-download-err.log"

tar -cjf "${TARBALL_NAME}.tar.bz2" "${TARBALL_DIR}"
if [ $? -ne 0 ]
then
    exit 1
fi

cat <<EOF > /home/travis/build/OpenCTR/OpenCTR/build/s3cfg
[default]
access_key = ${S3_ACCESS_KEY}
secret_key = ${S3_SECRET_KEY}
EOF

s3cmd \
  put \
  --guess-mime-type \
  --config=/home/travis/build/OpenCTR/OpenCTR/build/s3cfg \
  "${TARBALL_NAME}.tar.bz2" \
  "s3://openctr-upload-test/${TARBALL_NAME}.tar.bz2"
