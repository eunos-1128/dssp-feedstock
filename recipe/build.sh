#!/bin/bash

set -exo pipefail

export CMAKE_GENERATOR=Ninja

if [[ "$OSX_ARCH" == "x86_64" ]]; then
    export MACOSX_DEPLOYMENT_TARGET="10.15"
    export CXXFLAGS="${CXXFLAGS} -mmacosx-version-min=10.15"
fi

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
sed -i.bak \
  's|option(USE_RSRC "Use mrc to create resources" ON)|option(USE_RSRC "Use mrc to create resources" OFF)|' \
  CMakeLists.txt

cmake -S . -B build ${CMAKE_ARGS} \
    -DINSTALL_LIBRARY=ON \
    -DBUILD_PYTHON_MODULE=ON \
    -DCIFPP_SHARE_DIR="${PREFIX}/share/libcifpp" \
    ${ATOMIC_BUILTIN_FLAG}
    # -Dcifpp_DIR="${PREFIX}/libcifpp/lib/cmake/cifpp" \
    # -Dmcfp_DIR="${PREFIX}/libmcfp/lib/cmake/libmcfp" \
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build
popd
