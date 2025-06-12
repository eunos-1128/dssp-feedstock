@echo on

cmake -S . -B build ^
  %CMAKE_ARGS% ^
  -DINSTALL_LIBRARY=ON ^
  -DBUILD_PYTHON_MODULE=ON

cmake --build build --config Release --parallel %CPU_COUNT%
cmake --install build
