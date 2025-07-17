#!/bin/bash

set -exo pipefail

if [[ "$build_platform" != "$target_platform" ]]; then
    export ATOMIC_BUILTIN_FLAG="-D_CXX_ATOMIC_BUILTIN_EXITCODE=0"
fi

cmake -S . -B build \
    ${CMAKE_ARGS} \
    -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
    -DCMAKE_CXX_STANDARD=20 \
    -DBUILD_TESTING=OFF \
    -DINSTALL_LIBRARY=ON \
    -DBUILD_PYTHON_MODULE=ON \
    -DPython_ROOT_DIR="${PREFIX}" \
    -DCIFPP_SHARE_DIR="${PREFIX}/share/libcifpp" \
    -Dcifpp_DIR="${PREFIX}/lib/cmake/cifpp" \
    -Dmcfp_DIR="${PREFIX}/lib/cmake/mcfp" \
    "${ATOMIC_BUILTIN_FLAG}"
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build
