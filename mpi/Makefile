MPICXX=OMPI_CXX=hipcc mpicxx
CFLAGS=
LDFLAGS=
OBJ = 

all: saxpy_hip_mpi

saxpy_hip_mpi.o: saxpy_hip_mpi.cpp
	$(MPICXX) -c -o $@ $< $(CFLAGS)

saxpy_hip_mpi: saxpy_hip_mpi.o
	$(MPICXX) -o $@ $^ $(LDFLAGS)

clean:
	rm -f saxpy_hip_mpi.o saxpy_hip_mpi

.PHONY: clean all
