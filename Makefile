CC = gcc

OBJECTS = \
	file.c \
	cruncher.c \
	megatool.c

all: $(OBJECTS)
	$(CC) -O3 $(OBJECTS) -o megatool.exe

run: all
	./megatool
	./megatool -a ./bin/test.bin 00020000
	./megatool -a ./bin/test2.bin 00010000
	./megatool -a ./bin/test3.bin 00001400
	./megatool -c ./bin/test.bin.addr
	./megatool -c ./bin/test2.bin.addr
	./megatool -c ./bin/test3.bin.addr
	./megatool -i ./bin/test.bin.addr ./bin/test2.bin.addr ./bin/alldata.bin
