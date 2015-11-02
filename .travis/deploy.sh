#!/bin/sh

S3=$(which s3cmd)
if [ -z "${S3}" ]
then
    echo "s3cmd is NOT installed"
    exit 1
fi

${S3} \
  --access_key=${S3_ACCESS_KEY} \
  --secret_key=${S3_SECRET_KEY} \
  --ssl \
  --check-md5 \
  --acl-private \
  --server-side-encryption \
  --encoding="UTF-8" \
  --default-mime-type="binary/octet-stream" \
  --guess-mime-type \
  --human-readable-sizes \
  --no-progress \
  --quiet \
  --check-certificate \
  put \
  "/home/travis/build/OpenCTR/OpenCTR/dist/*.tar.bz2" \
  s3://openctr-upload-test
