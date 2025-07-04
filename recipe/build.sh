#!/bin/bash

set -exo pipefail

if [[ "$build_platform" != "$target_platform" ]]; then
    export ATOMIC_BUILTIN_FLAG="-D_CXX_ATOMIC_BUILTIN_EXITCODE=0"
fi

cmake -S . -B build \
    ${CMAKE_ARGS} \
    -DCMAKE_PREFIX_PATH="${PREFIX}" \
    -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
    -DCMAKE_CXX_STANDARD=20 \
    -DBUILD_TESTING=OFF \
    -DINSTALL_LIBRARY=ON \
    -DBUILD_PYTHON_MODULE=ON \
    -DPython_ROOT_DIR="${PREFIX}" \
    -DCIFPP_DATA_DIR='' \
    -DCIFPP_SHARE_DIR="${PREFIX}/share/libcifpp" \
    ${ATOMIC_BUILTIN_FLAG}
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build

# activaton and deactivation scripts
mkdir -p "${PREFIX}/etc/conda/activate.d"
mkdir -p "${PREFIX}/etc/conda/deactivate.d"
cp -f "${RECIPE_DIR}/activate.sh" "${PREFIX}/etc/conda/activate.d/env_vars.sh"
cp -f "${RECIPE_DIR}/deactivate.sh" "${PREFIX}/etc/conda/deactivate.d/env_vars.sh"
