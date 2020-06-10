#!/bin/bash

#  build-rust.sh
#  RNCardano
#
#  Created by Yehor Popovych on 10/21/18.
#  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.

set -e

HAS_CARGO_IN_PATH=`which cargo; echo $?`

if [ "$HAS_CARGO_IN_PATH" -ne "0" ]; then
    PATH="${HOME}/.cargo/bin:${PATH}"
fi

if [ -z "${PODS_TARGET_SRCROOT}" ]; then
    ROOT_DIR="${SRCROOT}/../rust"
else
    ROOT_DIR="${PODS_TARGET_SRCROOT}/../rust"
fi

cd "${ROOT_DIR}"

if [ "${CONFIGURATION}" = "Release" ]; then
    cargo lipo --xcode-integ
else
    env -i HOME="$HOME" LC_CTYPE="${LC_ALL:-${LC_CTYPE:-$LANG}}" \
        PATH="$PATH" USER="$USER" \
        cargo lipo --release
fi


# -cp -f "${SRCROOT}"/../rust/target/universal/release/*.a "${SRCROOT}"/rust/
# -cp -f "${SRCROOT}"/../rust/include/*.h "${SRCROOT}"/rust/
cp -f "${ROOT_DIR}"/target/universal/release/*.a "${ROOT_DIR}"/../ios/rust/
cp -f "${ROOT_DIR}"/include/*.h "${ROOT_DIR}"/../ios/rust/

exit 0
