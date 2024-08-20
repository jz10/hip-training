
all: saxpy_hip saxpy_cuda

saxpy_hip: saxpy_hip.cpp
	hipcc -o $@ $^

saxpy_cuda: saxpy_cuda.cpp
	nvcc -o $@ $^

clean:
	rm -f saxpy_hip saxpy_cuda

.PHONY: clean all
