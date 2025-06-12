@echo on

set CMAKE_GENERATOR=Ninja

pushd libcifpp
cmake -S . -B build %CMAKE_ARGS% ^
    -DCMAKE_INSTALL_PREFIX=%PREFIX%/libcifpp
cmake --build build --config Release --parallel %CPU_COUNT%
cmake --install build
popd

pushd libmcfp
cmake -S . -B build %CMAKE_ARGS% ^
    -DCMAKE_INSTALL_PREFIX=%PREFIX%/libmcfp
cmake --build build --config Release --parallel %CPU_COUNT%
cmake --install build
popd

pushd dssp
cmake -S . -B build %CMAKE_ARGS% ^
    -DINSTALL_LIBRARY=ON ^
    -DBUILD_PYTHON_MODULE=ON ^
    -Dcifpp_DIR="%PREFIX%/libcifpp/lib/cmake/cifpp" ^
    -Dlibmcfp_DIR="%PREFIX%/libmcfp/lib/cmake/libmcfp"
cmake --build build --config Release --parallel %CPU_COUNT%
cmake --install build
popd
