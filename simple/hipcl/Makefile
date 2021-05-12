CXX=clang++
LD=clang++-link
CFLAGS=-std=c++11
LDFLAGS=-lOpenCL -lhipcl

all: saxpy_hip

saxpy_hip.o: saxpy_hip.cpp
	$(CXX) -c -o $@ $< $(CFLAGS)

saxpy_hip: saxpy_hip.o
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	rm -f saxpy_hip.o saxpy_hip

.PHONY: clean all
