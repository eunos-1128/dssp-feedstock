#!/bin/bash

set -exo pipefail

if [[ "$OSTYPE" == "darwin"* ]]; then
    CMAKE_CXX_FLAGS="-D_LIBCPP_DISABLE_AVAILABILITY"
    if [[ "$target_platform" == "osx-arm64" ]]; then
        ATOMIC_BUILTIN_FLAG="-D_CXX_ATOMIC_BUILTIN_EXITCODE=0"
    fi
fi

cmake -S . -B build \
    ${CMAKE_ARGS} \
    -DINSTALL_LIBRARY=ON \
    -DBUILD_PYTHON_MODULE=ON \
    -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}" \
    -Dcifpp_DIR="${PREFIX}/lib/cmake/cifpp" \
    -Dlibmcfp_DIR="${PREFIX}/lib/cmake/libmcfp" \
    ${ATOMIC_BUILTIN_FLAG}

cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build
