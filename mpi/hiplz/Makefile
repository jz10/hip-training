MPICXX=OMPI_CXX=clang++ mpicxx
MPILD=OMPI_CXX=clang++-link mpicxx 
CFLAGS=-std=c++11
LDFLAGS=-lOpenCL -lhipcl -lze_loader
OBJ = 

all: saxpy_hip_mpi

saxpy_hip_mpi.o: saxpy_hip_mpi.cpp
	$(MPICXX) -c -o $@ $< $(CFLAGS)

saxpy_hip_mpi: saxpy_hip_mpi.o
	$(MPILD) -o $@ $^ $(LDFLAGS)

clean:
	rm -f saxpy_hip_mpi.o saxpy_hip_mpi

.PHONY: clean all
