@echo on

cmake -S . -B build %CMAKE_ARGS% ^
    -DCMAKE_CXX_FLAGS="%CXXFLAGS%" ^
    -DINSTALL_LIBRARY=ON ^
    -DBUILD_TESTING=OFF ^
    -DCIFPP_SHARE_DIR="%PREFIX%/share/libcifpp"
if errorlevel 1 exit 1

cmake --build build --config Release --parallel %CPU_COUNT%
if errorlevel 1 exit 1

cmake --install build
if errorlevel 1 exit 1
