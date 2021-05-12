CXX=clang++
LD=clang++-link
CFLAGS=-std=c++11
LDFLAGS=-lOpenCL -lhipcl -lze_loader
OBJ = saxpy_hip.o

all: saxpy_hip

saxpy_hip.o: saxpy_hip.cpp
	$(CXX) -c -o $@ $< $(CFLAGS)

saxpy_hip: $(OBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	rm -f saxpy_hip.o saxpy_hip

.PHONY: clean all
