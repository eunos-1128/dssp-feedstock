#!/bin/bash

set -exo pipefail

export CMAKE_GENERATOR=Ninja

if [[ "$target_platform" == "osx-x86_64" ]]; then
    export MACOSX_DEPLOYMENT_TARGET="10.15"
elif [[ "$target_platform" == "osx-arm64" ]]; then
    ATOMIC_BUILTIN_FLAG="-D_CXX_ATOMIC_BUILTIN_EXITCODE=0"
fi

pushd libcifpp
cmake -S . -B build ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}/libcifpp
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build
popd

pushd libmcfp
cmake -S . -B build ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}/libmcfp
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build
popd

pushd dssp
cmake -S . -B build ${CMAKE_ARGS} \
    -DINSTALL_LIBRARY=ON \
    -DBUILD_PYTHON_MODULE=ON \
    -Dcifpp_DIR="${PREFIX}/libcifpp/lib/cmake/cifpp" \
    -Dmcfp_DIR="${PREFIX}/libmcfp/lib/cmake/libmcfp" \
    ${ATOMIC_BUILTIN_FLAG}
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build
popd
