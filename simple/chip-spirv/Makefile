CXX=hipcc
LD=hipcc
CFLAGS=
LDFLAGS=
OBJ = saxpy_hip.o

all: saxpy_hip

saxpy_hip.o: saxpy_hip.cpp
	$(CXX) -c -o $@ $< $(CFLAGS)

saxpy_hip: $(OBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	rm -f saxpy_hip.o saxpy_hip

.PHONY: clean all
