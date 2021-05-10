# How to use HIPCL and HIPLZ on JLSE

This repository shows how to use HIPCL and HIPLZ to compile
and run simple programs on JLSE, a computer cluster at Argonne
National Laboratory.

This is not meant to be a HIP tutorial.

## Why does this repository exist / what's the background?

HIP is a likely programming model for many applications which are targeting exascale systems. Making HIP as portable as possible is thus in the interest of all involved parties. HIP is already supported on AMD and Nvidia accelerators, but other systems like [Aurora](https://www.alcf.anl.gov/aurora) will be based on Intel GPUs. Those GPUs can be programmed using the Intel Level Zero API or OpenCL. 

To enable HIP to run on Intel GPUs, the HIP API has been implemented with an OpenCL backend (HIPCL), and work has started on implementing the HIP API with the Level Zero backend (HIPLZ). More information on the implementations is below.

## Who is this for?

This repository contains instructions for people who want to try running HIP applications on Intel GPUs using HIPCL or HIPLZ on the Aurora testbed JLSE.

## What is HIPCL and HIPLZ?

[HIPCL](https://github.com/cpc/hipcl) is an implementation of the [HIP API](https://github.com/ROCm-Developer-Tools/HIP/blob/master/docs/markdown/hip_faq.md) on top of OpenCL and SPIR-V. 

[HIPLZ](https://github.com/jz10/anl-gt-gpu) is an implementation of the HIP API on top of [Intel's Level Zero API](https://spec.oneapi.com/level-zero/latest/index.html). 

Both HIPCL and HIPLZ can run on Intel GPUs. That is, OpenCL and Level Zero can both be used as backends of HIP to run on Intel GPUs. However, not all functions have been implemented yet, see the Known Issues and Pitfalls section

## Known Issues and Pitfalls

### Known Issues
1. Please review the issues here:
[Known libHIPCL Issues](https://github.com/cpc/hipcl#known-libhipcl-issues) to
see if a function you want to use is implemented in HIPCL. We don't currently have the
equivalent list for HIPLZ, but it is planned.
2. Note that constant memory is not properly handled by HIPCL/HIPLZ compiler for now, so general device memory should be used instead.

### Pitfalls
1. If you use cmake on JLSE, make sure to point to the FindHIP.cmake which is inside of the HIPCL repo
2. Although currently math libraries like Intel MKL will run on Intel GPUs, we have not yet tested compiling or running a HIP application with HIPCL/HIPLZ and linking an Intel math library.

## What is JLSE?

The Joint Laboratory for System Evaluation (JLSE) is computing
cluster at Argonne National Lab meant as a testbed system
(https://www.jlse.anl.gov/).

It contains Intel Gen9 GPUs, which HIPCL and HIPLZ can target.

This tutorial assumes you have access to JLSE.

## Steps to compile and run simple examples in this repo 

### 1. Get a Intel Gen9 GPU node on JLSE

To get an interactive job (i.e. a job with a shell) on one of
the Intel Gen9 GPUs on JLSE
 
```
$ qsub -I -n 1 -q iris -t 360
```

### 2A. Compile and run HIP code with HIPCL

First set the environment:

```
$ module use /soft/modulefiles # put the appropriate modules in your path
$ module purge # remove any modules from your environment
$ module load intel_compute_runtime # puts the latest Intel OpenCL and L0 runtimes in your environment
$ module load hipcl
```

Next compile the simple HIP codes. There are two examples, one with
just a makefile (the simplest version) and one with cmake (slightly
more complicated)

Makefile version:
```
$ cd hipcl
$ make
clang++ -c -o saxpy_hip.o saxpy_hip.cpp -std=c++11
clang++-link -o saxpy_hip saxpy_hip.o -lOpenCL -lhipcl
$ ./saxpy_hip 
Max error: 0.000000
```

Note here that we:
 - compile with "clang++"
 - link with "clang++-link" and flags "-lOpenCL -lhipcl"

Cmake version:
```
$ cd hipcl
$ module load cmake
$ mkdir build
$ cd build
$ HIP_PATH=/soft/compilers/clang-hipcl/8.0-20210108/ cmake ../
$ make
$ ./saxpy_hip 
Max error: 0.000000
```

### 2B. Compile and run HIP code with HIPLZ

First set the environment:
```
$ module use /soft/modulefiles # put the appropriate modules in your path
$ module purge # remove any modules from your environment
$ module load intel_compute_runtime # puts the latest Intel OpenCL and L0 runtimes in your environment
$ module load hiplz

```
Makefile version:
```
$ cd hiplz
$ make
clang++ -c -o saxpy_hip.o saxpy_hip.cpp -std=c++11
clang++-link -o saxpy_hip saxpy_hip.o -lOpenCL -lhipcl -lze_loader
$ ./saxpy_hip 
Max error: 0.000000
```

Cmake version:
```
$ cd hiplz
$ module load cmake
$ mkdir build
$ cd build
$ HIP_PATH=/soft/compilers/clang-hipcl/8.0-20210108/ cmake ../
$ make
$ ./saxpy_hip 
Max error: 0.000000
```

Note here that we:
 - compile with "clang++"
 - link with "clang++-link" and flags "-lOpenCL -lhipcl -lze_loader"
