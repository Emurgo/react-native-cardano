#!/bin/bash

#  build-rust.sh
#  RNCardano
#
#  Created by Yehor Popovych on 10/21/18.
#  Copyright © 2018 Crossroad Labs s.r.o. All rights reserved.

set -e

HAS_CARGO_IN_PATH=`which cargo; echo $?`

# when cocoapods is used PODS_TARGET_SRCROOT=path(podspec)
if [ "$HAS_CARGO_IN_PATH" -ne "0" ]; then
    PATH="${HOME}/.cargo/bin:${PATH}"
fi

if [ -z "${PODS_TARGET_SRCROOT}" ]; then
    ROOT_DIR="${SRCROOT}/../rust"
else
    ROOT_DIR="${PODS_TARGET_SRCROOT}/rust"
fi

if [[ -n "${DEVELOPER_SDK_DIR:-}" ]]; then
  # Assume we're in Xcode, which means we're probably cross-compiling.
  # In this case, we need to add an extra library search path for build scripts and proc-macros,
  # which run on the host instead of the target.
  # (macOS Big Sur does not have linkable libraries in /usr/lib/.)
  export LIBRARY_PATH="${DEVELOPER_SDK_DIR}/MacOSX.sdk/usr/lib:${LIBRARY_PATH:-}"
fi

OUTPUT_DIR=`echo "${CONFIGURATION}" | tr '[:upper:]' '[:lower:]'`

cd "${ROOT_DIR}"

cargo lipo --xcode-integ

mkdir -p "${CONFIGURATION_BUILD_DIR}"

cp -f "${ROOT_DIR}"/target/universal/"${OUTPUT_DIR}"/*.a "${CONFIGURATION_BUILD_DIR}"/
cp -f "${ROOT_DIR}"/include/*.h "${CONFIGURATION_BUILD_DIR}"/

exit 0
