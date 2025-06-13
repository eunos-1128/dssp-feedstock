#!/bin/bash

set -exo pipefail

if [[ "$target_platform" == "osx-arm64" ]]; then
    ATOMIC_BUILTIN_FLAG="-D_CXX_ATOMIC_BUILTIN_EXITCODE=0"
fi

# pushd libcifpp
# cmake -S . -B build ${CMAKE_ARGS} \
#     -DCMAKE_INSTALL_PREFIX=${PREFIX}/libcifpp
# cmake --build build --config Release --parallel "${CPU_COUNT}"
# cmake --install build
# popd

# pushd libmcfp
# cmake -S . -B build ${CMAKE_ARGS} \
#     -DCMAKE_INSTALL_PREFIX=${PREFIX}/libmcfp
# cmake --build build --config Release --parallel "${CPU_COUNT}"
# cmake --install build
# popd

pushd dssp

cmake -S . -B build ${CMAKE_ARGS} \
    -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET}" \
    -DBUILD_TESTING=OFF \
    -DINSTALL_LIBRARY=ON \
    -DBUILD_PYTHON_MODULE=ON \
    -DCIFPP_SHARE_DIR="${PREFIX}/share/libcifpp" \
    ${ATOMIC_BUILTIN_FLAG}
    # -Dcifpp_DIR="${PREFIX}/libcifpp/lib/cmake/cifpp" \
    # -Dmcfp_DIR="${PREFIX}/libmcfp/lib/cmake/libmcfp" \
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build
popd
