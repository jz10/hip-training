CXX=hipcc
LD=hipcc
CFLAGS=
LDFLAGS=

all: saxpy_hip saxpy_cuda

saxpy_hip.o: saxpy_hip.cpp
	$(CXX) -c -o $@ $< $(CFLAGS)

saxpy_hip: saxpy_hip.o
	$(LD) -o $@ $^ $(LDFLAGS)

saxpy_cuda.o: saxpy_cuda.cu
	$(CXX) -c -o $@ $< $(CFLAGS)

saxpy_cuda: saxpy_cuda.o
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	rm -f saxpy_hip.o saxpy_hip

.PHONY: clean all
