#!/bin/bash

set -exo pipefail

if [[ "${OSX_ARCH}" == "x86_64" ]]; then
    export CXXFLAGS="${CXXFLAGS} -mmacosx-version-min=10.15"
elif [[ "$target_platform" == "osx-arm64" ]]; then
    export ATOMIC_BUILTIN_FLAG="-D_CXX_ATOMIC_BUILTIN_EXITCODE=0"
fi

cmake -S . -B build ${CMAKE_ARGS} \
    -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET}" \
    -DBUILD_TESTING=OFF \
    -DINSTALL_LIBRARY=ON \
    -DBUILD_PYTHON_MODULE=ON \
    -DCIFPP_SHARE_DIR="${PREFIX}/share/libcifpp" \
    ${ATOMIC_BUILTIN_FLAG}
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build
