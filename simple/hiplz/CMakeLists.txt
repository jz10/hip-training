cmake_minimum_required(VERSION 2.8.3)

# set HIP_PATH if not in the env
if(NOT DEFINED HIP_PATH)
    if(NOT DEFINED ENV{HIP_PATH})
        set(HIP_PATH "/opt/rocm/hip" CACHE PATH "Path to which HIP has been installed")
    else()
        set(HIP_PATH $ENV{HIP_PATH} CACHE PATH "Path to which HIP has been installed")
    endif()
endif()

# set CMAKE_MODULE_PATH to point to the right FindHIP.cmake
# note this change 
#set(CMAKE_MODULE_PATH "${HIP_PATH}/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_MODULE_PATH "$ENV{HIPLZ_DIR}/cmake" ${CMAKE_MODULE_PATH})

project(hello)

# find HIP
find_package(HIP)
if(HIP_FOUND)
    message(STATUS "Found HIP: " ${HIP_VERSION})
else()
    message(FATAL_ERROR "Could not find HIP. Ensure that the variable HIP_PATH is set to point to the right location.")
endif()

set(MY_SOURCE_FILES saxpy_hip.cpp)
set(MY_TARGET_NAME saxpy_hip)
set(MY_HIPCC_OPTIONS)
set(MY_HCC_OPTIONS)
set(MY_NVCC_OPTIONS)

set_source_files_properties(${MY_SOURCE_FILES} PROPERTIES HIP_SOURCE_PROPERTY_FORMAT 1)


# hip_add_executable macro is similar to the cuda_add_executable macro that is provided by FindCUDA
# Ok, I just realized that FindCUDA is deprecated, so need to figure out a different way

SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -lze_loader")

hip_add_executable(${MY_TARGET_NAME} ${MY_SOURCE_FILES} HIPCC_OPTIONS ${MY_HIPCC_OPTIONS} HCC_OPTIONS ${MY_HCC_OPTIONS} NVCC_OPTIONS ${MY_NVCC_OPTIONS})
