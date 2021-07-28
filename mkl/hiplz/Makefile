CXX=clang++
LD=clang++-link
CFLAGS=-g -pthread -std=c++14 -fPIE
#Add -x hip if you are not using the clang wrappers on JLSE
LDFLAGS=-L /soft/libraries/pocl/OpenCL-ICD-Loader/build-v2020.06.16/ -lOpenCL -lze_loader -lhiplz

# Include compiler and flags for DPC++
# Note we specify this as a different variable as it uses the OneAPI version of clang++
DPCPP_CXX=clang++
DPCPP_LDFLAGS=-DMKL_ILP64 -lmkl_sycl -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core
DPCPP_CFLAGS=-fsycl -shared -fPIC

MKL_EXE=hiplz_mkl_interop
MKL_NB_EXE=hiplz_mkl_nobuffer_interop

MKL_OBJ = ${MKL_EXE}.o
MKL_NB_OBJ = ${MKL_NB_EXE}.o
SYCL_LIB = onemkl_gemm_wrapper.so

all: ${MKL_EXE}.exe ${MKL_NB_EXE}.exe

# Note that we are loading modules here and then purging the environment at the end
# This is because we need to build the SYCL library with one tool and then link with another tool 
${SYCL_LIB}: onemkl_gemm_wrapper.cpp
	module unload hiplz/HIAI05-12; \
	module use /home/jyoung/gpfs_share/compilers/modulefiles/oneapi/2020.2.0.2997/; \
	module load mkl compiler; \
	$(DPCPP_CXX) $(DPCPP_LDFLAGS) -o $@ $< $(DPCPP_CFLAGS); \
	module unload mkl compiler

${MKL_EXE}.o: ${MKL_EXE}.cpp
	module load hiplz/HIAI05-12; \
	$(CXX) -c -o $@ $< $(CFLAGS)

${MKL_EXE}.exe: $(MKL_OBJ) $(SYCL_LIB)
	module load hiplz/HIAI05-12; \
	$(LD) -o $@ $^ $(LDFLAGS)

## No Buffer version of the code
${MKL_NB_EXE}.o: ${MKL_NB_EXE}.cpp
	module load hiplz/HIAI05-12; \
	$(CXX) -c -o $@ $< $(CFLAGS)

${MKL_NB_EXE}.exe: $(MKL_NB_OBJ) $(SYCL_LIB)
	module load hiplz/HIAI05-12; \
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	rm -f *.o *.exe ${SYCL_LIB}

run_mkl:
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:. ./$(MKL_EXE).exe

run_mkl_nb:
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:. ./$(MKL_NB_EXE).exe

.PHONY: clean all

.PHONY : run

