project(simple)

cmake_minimum_required(VERSION 3.10)

# Search for rocm in common locations
list(APPEND CMAKE_MODULES_PREFIX $ENV{HIP_PATH}/cmake)
list(APPEND CMAKE_PREFIX_PATH $ENV{HIP_PATH})

# Find hip
find_package(hip)

# Set compiler and linker
set(CMAKE_BUILD_TYPE Release)

# Create the excutable
add_executable(saxpy_hip saxpy_hip.cpp)

# Link with HIP
target_link_libraries(saxpy_hip hip::device)
