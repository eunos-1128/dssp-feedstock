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

@REM Define the relative path to the CMakeLists.txt file we want to patch
set "FILE=python-module\CMakeLists.txt"

@REM Adjust the install() destination to use CMAKE_INSTALL_PREFIX/Lib/site-packages
@REM After find_package(Python3 ...), inject logic to override Python library names on Windows/MSVC
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "(Get-Content -Raw '%FILE%') " ^
    "-replace 'install\\(TARGETS mkdssp_module RUNTIME DESTINATION \"\\$\\{Python_SITELIB\\}\"\\)', 'install(TARGETS mkdssp_module RUNTIME DESTINATION \"${CMAKE_INSTALL_PREFIX}/Lib/site-packages\")' " ^
    "-replace 'find_package\\(Python3 REQUIRED COMPONENTS Interpreter Development\\)', 'find_package(Python3 REQUIRED COMPONENTS Interpreter Development)`nif (WIN32 AND MSVC)`n  set(Python3_LIBRARY_DEBUG   \"${CMAKE_INSTALL_PREFIX}/Library/libs/python313.lib\" CACHE FILEPATH \"\" FORCE)`n  set(Python3_LIBRARY_RELEASE \"${CMAKE_INSTALL_PREFIX}/Library/libs/python313.lib\" CACHE FILEPATH \"\" FORCE)`nendif()' " ^
    "| Set-Content -NoNewline -Path '%FILE%'"

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
