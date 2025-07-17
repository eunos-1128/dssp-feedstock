#!/bin/bash

set -exo pipefail

if [[ "$build_platform" != "$target_platform" ]]; then
    EXTRA_ARGS="-D_CXX_ATOMIC_BUILTIN_EXITCODE=0"
fi

if [[ "${target_platform}" == "linux-ppc64le" ]]; then
    EXTRA_ARGS="${EXTRA_ARGS} -DCIFPP_DATA_DIR=''"
else
    # Workaround due to `CIFPP_DATA_DIR` set to an empty string in libcifpp conda package
    sed -i.bak 's|${CIFPP_DATA_DIR}/mmcif_pdbx.dic|$ENV{PREFIX}/share/libcifpp/mmcif_pdbx.dic|g' CMakeLists.txt
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
    ${EXTRA_ARGS}
cmake --build build --config Release --parallel "${CPU_COUNT}"
cmake --install build

if [[ "${target_platform}" == "linux-ppc64le" ]]; then
    # activaton and deactivation scripts
    mkdir -p "${PREFIX}/etc/conda/activate.d"
    mkdir -p "${PREFIX}/etc/conda/deactivate.d"
    cp -f "${RECIPE_DIR}/activate.sh" "${PREFIX}/etc/conda/activate.d/env_vars.sh"
    cp -f "${RECIPE_DIR}/deactivate.sh" "${PREFIX}/etc/conda/deactivate.d/env_vars.sh"
fi
