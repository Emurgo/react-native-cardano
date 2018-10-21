#!/bin/bash

#  build-rust.sh
#  RNCardano
#
#  Created by Yehor Popovych on 10/21/18.
#  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.

set -e
source ~/.bashrc

cd "${SRCROOT}"/../rust

env -i HOME="$HOME" LC_CTYPE="${LC_ALL:-${LC_CTYPE:-$LANG}}" \
    PATH="$PATH" USER="$USER" \
    cargo lipo --release

cp -f "${SRCROOT}"/../rust/target/universal/release/*.a "${SRCROOT}"/rust/
cp -f "${SRCROOT}"/../rust/include/*.h "${SRCROOT}"/rust/

exit 0
