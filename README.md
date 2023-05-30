# How to use CHIP-SPV on JLSE

This repository shows how to use CHIP-SPV to compile
and run simple programs on JLSE, a computer cluster at Argonne
National Laboratory.

This is not meant to be a HIP tutorial.

## Why does this repository exist / what's the background?

HIP is a likely programming model for many applications which are targeting exascale systems. Making HIP as portable as possible is thus in the interest of all involved parties. HIP is already supported on AMD and Nvidia accelerators, but other systems like [Aurora](https://www.alcf.anl.gov/aurora) will be based on Intel GPUs. Those GPUs can be programmed using the Intel Level Zero API or OpenCL. 

To enable HIP to run on Intel GPUs, the HIP API has been implemented with an OpenCL backend (HIPCL), and work has started on implementing the HIP API with the Level Zero backend (HIPLZ). This evolved into CHIP-SPV. More information on the implementations is below.

## Who is this for?

This repository contains instructions for people who want to try running HIP applications on Intel GPUs using HIPCL or HIPLZ on the Aurora testbed JLSE.

## What is CHIP-SPV, HIPCL, and HIPLZ?

[HIPCL](https://github.com/cpc/hipcl) is an implementation of the [HIP API](https://github.com/ROCm-Developer-Tools/HIP/blob/master/docs/markdown/hip_faq.md) on top of OpenCL and SPIR-V. 

[HIPLZ](https://github.com/jz10/anl-gt-gpu) is an implementation of the HIP API on top of [Intel's Level Zero API](https://spec.oneapi.com/level-zero/latest/index.html). 

[CHIP-SPV](https://github.com/CHIP-SPV/chip-spv) is an implementation of the HIP API on top of Intel's Level Zero API and OpenCL. This is a replacement for HIPLZ and HIPCL as it can run on both backends.

CHIP-SPV, HIPCL, and HIPLZ can run on Intel GPUs. That is, OpenCL and Level Zero can both be used as backends of HIP to run on Intel GPUs. However, not all functions have been implemented yet, see the Known Issues and Pitfalls section

## Known Issues and Pitfalls

### Support Status
1. Please review the issues here:
[CHIP-SPV Support status](https://github.com/CHIP-SPV/chip-spv/blob/main/docs/Features.md).

### Pitfalls
1. If you use cmake on JLSE, make sure to point to the FindHIP.cmake which is inside of the CHIP-SPV repo

## What is JLSE?

The Joint Laboratory for System Evaluation (JLSE) is computing
cluster at Argonne National Lab meant as a testbed system
(https://www.jlse.anl.gov/).

It contains Intel Gen9 GPUs, which HIPCL and HIPLZ can target.

This tutorial assumes you have access to JLSE.

## Steps to compile and run examples in the "simple" subdirectory in this repo 

### 1. Get a Intel Gen9 GPU node on JLSE

To get an interactive job (i.e. a job with a shell) on one of
the Intel Gen9 GPUs on JLSE
 
```
$ qsub -I -n 1 -q iris -t 360
```

### 2. Compile and run HIP code with CHIP-SPV

First set the environment:

```
$ module use /soft/modulefiles # put the appropriate modules in your path
$ module purge # remove any modules from your environment
$ module load intel_compute_runtime # puts the latest Intel OpenCL and L0 runtimes in your environment
$ module load chip-spv
```

Next compile the simple HIP codes. There are two examples, one with
just a makefile (the simplest version) and one with cmake (slightly
more complicated)

Makefile version:
```
$ cd simple
$ make
hipcc -c -o saxpy_hip.o saxpy_hip.cpp 
hipcc -o saxpy_hip saxpy_hip.o 
$ ./saxpy_hip 
Max error: 0.000000
```

Cmake version:
```
$ cd simple
$ module load cmake
$ mkdir build
$ cd build
$ cmake -DCMAKE_CXX_COMPILER=clang++ ../
$ make
$ ./saxpy_hip 
Max error: 0.000000
```


## Steps to compile and run examples in the "mpi" subdirectory in this repo 

### 1. Get a Intel Gen9 GPU node on JLSE

To get an interactive job (i.e. a job with a shell) on one of
the Intel Gen9 GPUs on JLSE
 
```
$ qsub -I -n 1 -q iris -t 360
```

### 2. Compile and run HIP code with CHIP-SPV

First set the environment:

```
$ module use /soft/modulefiles # put the appropriate modules in your path
$ module purge # remove any modules from your environment
$ module load intel_compute_runtime # puts the latest Intel OpenCL and L0 runtimes in your environment
$ module load chip-spv
$ module load openmpi/4.1.1-llvm
```

Makefile version:
```
$ cd mpi
$ make
OMPI_CXX=hipcc mpicxx -c -o saxpy_hip_mpi.o saxpy_hip_mpi.cpp 
OMPI_CXX=hipcc mpicxx -o saxpy_hip_mpi saxpy_hip_mpi.o 
$ mpirun -n 2 ./saxpy_hip_mpi
Rank: 1 Device: 0
Rank: 0 Device: 0
Max error: 0.000000
Max error: 0.000000
```

## Debugging and Profiling

The simplest debugging and profiling tool on JLSE is called "iprof". It prints a breakdown of host API calls and device kernels. It can be used as shown below:

```
$ module load iprof
$ iprof ./saxpy_hip
Max error: 0.000000
Trace location: /home/bertoni/lttng-traces/iprof-20210512-165535

== OpenCL ==
API calls | 1 Hostnames | 1 Processes | 1 Threads

                                    Name |     Time | Time(%) | Calls |  Average |      Min |      Max |
                           clLinkProgram | 100.51ms |  95.91% |     1 | 100.51ms | 100.51ms | 100.51ms |
                      clEnqueueSVMMemcpy |   2.59ms |   2.47% |     3 | 861.77us | 168.10us |   1.70ms |
                                clFinish |   1.15ms |   1.10% |     3 | 384.90us | 319.52us | 479.22us |
                          clGetDeviceIDs | 202.17us |   0.19% |     2 | 101.09us |   2.33us | 199.84us |
clGetExtensionFunctionAddressForPlatform | 104.54us |   0.10% |     2 |  52.27us |   2.36us | 102.18us |
                          clReleaseEvent |  55.83us |   0.05% |     5 |  11.17us | 273.00ns |  30.51us |
                  clEnqueueNDRangeKernel |  45.51us |   0.04% |     1 |  45.51us |  45.51us |  45.51us |
                              clSVMAlloc |  17.14us |   0.02% |     2 |   8.57us |   5.22us |  11.92us |
                        clReleaseProgram |  12.79us |   0.01% |     2 |   6.39us |   4.49us |   8.30us |
                               clSVMFree |  11.57us |   0.01% |     2 |   5.78us |   2.55us |   9.02us |
                        clCompileProgram |  11.28us |   0.01% |     1 |  11.28us |  11.28us |  11.28us |
                         clGetDeviceInfo |   8.69us |   0.01% |    24 | 362.00ns | 233.00ns | 775.00ns |
                clCreateKernelsInProgram |   8.07us |   0.01% |     2 |   4.04us |   1.19us |   6.88us |
                         clCreateContext |   7.74us |   0.01% |     1 |   7.74us |   7.74us |   7.74us |
      clCreateCommandQueueWithProperties |   7.22us |   0.01% |     1 |   7.22us |   7.22us |   7.22us |
                clSetKernelArgSVMPointer |   6.14us |   0.01% |     2 |   3.07us |   1.90us |   4.24us |
                   clCreateProgramWithIL |   5.26us |   0.01% |     1 |   5.26us |   5.26us |   5.26us |
                         clReleaseKernel |   5.25us |   0.01% |     8 | 656.00ns | 162.00ns |   3.24us |
                         clReleaseDevice |   4.31us |   0.00% |     8 | 538.00ns | 221.00ns |   1.05us |
                clCreateContext_callback |   4.27us |   0.00% |     4 |   1.07us | 338.00ns |   2.67us |
                    clRetainCommandQueue |   4.17us |   0.00% |     2 |   2.08us | 193.00ns |   3.98us |
                        clReleaseContext |   4.07us |   0.00% |     5 | 813.00ns | 248.00ns |   1.81us |
                        clGetPlatformIDs |   3.42us |   0.00% |     2 |   1.71us | 788.00ns |   2.63us |
                   clReleaseCommandQueue |   3.38us |   0.00% |     3 |   1.13us | 266.00ns |   2.04us |
                   clGetProgramBuildInfo |   3.23us |   0.00% |     6 | 538.00ns | 321.00ns | 892.00ns |
                          clRetainDevice |   2.74us |   0.00% |     8 | 342.00ns | 197.00ns | 796.00ns |
                         clRetainContext |   2.44us |   0.00% |     4 | 610.00ns | 186.00ns |   1.25us |
                          clSetKernelArg |   2.30us |   0.00% |     2 |   1.15us | 512.00ns |   1.79us |
                          clRetainKernel |   2.13us |   0.00% |     7 | 304.00ns | 143.00ns | 921.00ns |
                        clGetProgramInfo |   1.21us |   0.00% |     2 | 606.00ns | 383.00ns | 830.00ns |
                         clGetKernelInfo | 964.00ns |   0.00% |     3 | 321.00ns | 225.00ns | 494.00ns |
                clUnloadPlatformCompiler | 557.00ns |   0.00% |     1 | 557.00ns | 557.00ns | 557.00ns |
                           clRetainEvent | 398.00ns |   0.00% |     1 | 398.00ns | 398.00ns | 398.00ns |
                                   Total | 104.80ms | 100.00% |   121 |

Device profiling | 1 Hostnames | 1 Processes | 1 Threads | 1 Device pointers

              Name |     Time | Time(%) | Calls |  Average |      Min |      Max |
clEnqueueSVMMemcpy | 933.75us |  81.03% |     3 | 311.25us | 165.33us | 411.00us |
    _Z5saxpyifPfS_ | 218.67us |  18.97% |     1 | 218.67us | 218.67us | 218.67us |
             Total |   1.15ms | 100.00% |     4 |

Explicit memory trafic | 1 Hostnames | 1 Processes | 1 Threads

              Name |    Byte | Byte(%) | Calls | Average |    Min |    Max |
clEnqueueSVMMemcpy | 12.58MB | 100.00% |     3 |  4.19MB | 4.19MB | 4.19MB |
             Total | 12.58MB | 100.00% |     3 |

```
