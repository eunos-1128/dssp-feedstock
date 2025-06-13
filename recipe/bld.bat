@echo on

@REM pushd libcifpp
@REM cmake -S . -B build %CMAKE_ARGS% ^
@REM     -DCMAKE_INSTALL_PREFIX=%PREFIX%/libcifpp
@REM cmake --build build --config Release --parallel %CPU_COUNT%
@REM cmake --install build
@REM popd

@REM pushd libmcfp
@REM cmake -S . -B build %CMAKE_ARGS% ^
@REM     -DCMAKE_INSTALL_PREFIX=%PREFIX%/libmcfp
@REM cmake --build build --config Release --parallel %CPU_COUNT%
@REM cmake --install build
@REM popd

pushd dssp
cmake -S . -B build %CMAKE_ARGS% ^
    -DCMAKE_CXX_FLAGS="%CXXFLAGS%" ^
    -DINSTALL_LIBRARY=ON ^
    -DBUILD_PYTHON_MODULE=ON ^
    -DCIFPP_SHARE_DIR="%PREFIX%/share/libcifpp"
    @REM -Dcifpp_DIR="%PREFIX%/libcifpp/lib/cmake/cifpp" ^
    @REM -Dlibmcfp_DIR="%PREFIX%/libmcfp/lib/cmake/libmcfp"
cmake --build build --config Release --parallel %CPU_COUNT%
cmake --install build
popd
