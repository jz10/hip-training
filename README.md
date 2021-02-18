# How to use HIPCL and HIPLZ on JLSE

This repository shows how to use HIPCL and HIPLZ to compile
and run simple programs on JLSE, a computer cluster at Argonne
National Laboratory.

This is not meant to be a HIP tutorial.

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
$ module load cmake
$ module load hipcl/master-20210208  
$ mkdir build
$ cd build
$ HIP_PATH=/soft/compilers/clang-hipcl/8.0-20210108/ cmake ../
$ make
$ ./saxpy_hip 
Max error: 0.000000
```

### 2B. Compile and run HIP code with HIPLZ

```
$ module use /soft/modulefiles # put the appropriate modules in your path
$ module purge # remove any modules from your environment
$ module load intel_compute_runtime # puts the latest Intel OpenCL and L0 runtimes in your environment
$ module load hipcl

```