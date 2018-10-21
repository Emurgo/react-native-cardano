#!/bin/bash

#  build-rust.sh
#  RNCardano
#
#  Created by Yehor Popovych on 10/21/18.
#  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.

set -e
source ~/.bashrc

cd "${SRCROOT}"/../rust

if [ "${CONFIGURATION}" = "Release" ]
then
    cargo lipo --release
    cp -f "${SRCROOT}"/../rust/target/universal/release/*.a "${SRCROOT}"/lib/
else
    cargo lipo --verbose
    cp -f "${SRCROOT}"/../rust/target/universal/debug/*.a "${SRCROOT}"/lib/
fi

exit 0
