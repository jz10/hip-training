## MKL and HIPLZ-OneAPI Interoperability Example 

This directory contains an example of using Intel's MKL library with the HIP Level Zero
library. Currently HIPCL does not support this integration of MKL code with HIP code.

This directory contains the following files:
* hiplz_mkl_interop.cpp - HIPLZ host code that calls an MKL GEMM function
* hiplz_mkl_interop.h - header file that wraps the OneAPI MKL test function
* onemkl_gemm_wrapper.cpp - OneAPI/SYCL file with MKL GEMM functionality using a shared level zero context
* Makefile - Makefile that uses two compilers, hiplz and DPC++, to compile the HIPLZ and OneAPI MKL code.

## Steps to compile and run examples in the "mkl" subdirectory in this repo 

### 1. Get a Intel Gen9 GPU node on JLSE

To get an interactive job (i.e. a job with a shell) on one of the Intel Gen9 GPUs on JLSE

```
$ qsub -I -n 1 -q iris -t 360
```


### 2A. Compile and run HIPLZ and MKL Interoperability Example

Note that this example uses two different compilers that are switched within the Makefile. However, both use the same base module in the Intel runtime. The included Makefile also shows which modules are needed to compile each file.
```
$ module use /soft/modulefiles # put the appropriate modules in your path
$ module purge # remove any modules from your environment
$ module load intel_compute_runtime # puts the latest Intel OpenCL and L0 runtimes in your environment
```

Makefile version:
```
//Compile the host HIPLZ code
$ make
module unload compiler; \
module load hiplz/HIAI05-12; \
clang++ -c -o hiplz_mkl_interop.o hiplz_mkl_interop.cpp -g -pthread -std=c++14 -fPIE

//Compile the MKL function into a shared library with OneAPI
module unload hiplz/HIAI05-12; \
module use /home/jyoung/gpfs_share/compilers/modulefiles/oneapi/2020.2.0.2997/; \
module load mkl compiler; \
clang++ -DMKL_ILP64 -lmkl_sycl -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -o onemkl_gemm_wrapper.so onemkl_gemm_wrapper.cpp -fsycl -shared -fPIC

//This is the linking stage to combine HIPLZ code and the MKL SYCL library
Unloading hiplz/HIAI05-12
  WARNING: Did not unuse /soft/packaging/spack-builds/modules/linux-opensuse_leap15-x86_64
Loading compiler version 2021.2.0
Loading debugger version 10.1.1
Loading dpl version 2021.2.0
Loading oclfpga version 2021.2.0

Loading compiler/latest
  Loading requirement: debugger/latest dpl/latest /gpfs/jlse-fs0/users/jyoung/compilers/oneapi/2020.2.0/compiler/2021.2.0/linux/lib/oclfpga/modulefiles/oclfpga
module load hiplz/HIAI05-12; \
clang++-link -o hiplz_mkl_interop.exe hiplz_mkl_interop.o onemkl_gemm_wrapper.so -L /soft/libraries/pocl/OpenCL-ICD-Loader/build-v2020.06.16/ -lOpenCL -lze_loader -lhiplz

$ LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. ./hiplz_mkl_interop.exe
Verify results between OneMKL & Serial: SUCCESS - The results are correct!
```
