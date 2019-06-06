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

cd "${SRCROOT}"/../rust

cargo lipo --xcode-integ

cp -f "${SRCROOT}"/../rust/target/universal/release/*.a "${SRCROOT}"/rust/
cp -f "${SRCROOT}"/../rust/include/*.h "${SRCROOT}"/rust/

exit 0
