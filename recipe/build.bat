@echo on

cmake -S . -B build %CMAKE_ARGS% ^
    -DCMAKE_CXX_FLAGS="%CXXFLAGS%" ^
    -DCMAKE_CXX_STANDARD=20 ^
    -DBUILD_TESTING=OFF ^
    -DINSTALL_LIBRARY=ON ^
    -DBUILD_PYTHON_MODULE=ON ^
    -DCIFPP_DATA_DIR='' ^
    -DCIFPP_SHARE_DIR="%PREFIX%/share/libcifpp"
if errorlevel 1 exit 1

cmake --build build --config Release --parallel %CPU_COUNT%
if errorlevel 1 exit 1

cmake --install build
if errorlevel 1 exit 1

@REM activaton and deactivation scripts for Windows
mkdir "%PREFIX%\etc\conda\activate.d" 2>nul
mkdir "%PREFIX%\etc\conda\deactivate.d" 2>nul
copy /Y "%RECIPE_DIR%\activate.bat" "%PREFIX%\etc\conda\activate.d\env_vars.bat"
copy /Y "%RECIPE_DIR%\deactivate.bat" "%PREFIX%\etc\conda\deactivate.d\env_vars.bat"
if errorlevel 1 exit 1
