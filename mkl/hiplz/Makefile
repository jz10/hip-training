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

EXE=hiplz_mkl_interop

HIPLZ_OBJ = ${EXE}.o
SYCL_LIB = onemkl_gemm_wrapper.so

all: ${EXE}.exe

${SYCL_LIB}: onemkl_gemm_wrapper.cpp
	module unload hiplz; \
	module use /home/ac.jyoung/gpfs_share/compilers/modulefiles/oneapi/2021.3.0/; \
	module load mkl compiler; \
	$(DPCPP_CXX) $(DPCPP_LDFLAGS) -o $@ $< $(DPCPP_CFLAGS)

${EXE}.o: ${EXE}.cpp
	module unload compiler; \
	module load hiplz; \
	$(CXX) -c -o $@ $< $(CFLAGS)

${EXE}.exe: $(HIPLZ_OBJ) $(SYCL_LIB)
	module use /home/ac.jyoung/gpfs_share/compilers/modulefiles/oneapi/2021.3.0/; \
	module load mkl; \
	module load hiplz; \
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	rm -f ${EXE}.o ${EXE} ${SYCL_LIB}

run:
	module use /home/ac.jyoung/gpfs_share/compilers/modulefiles/oneapi/2021.3.0/; \
	module load mkl; \
	module load hiplz
	LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:. ./$(EXE).exe

.PHONY: clean all

.PHONY : run

