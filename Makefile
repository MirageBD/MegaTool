# DecrZeroInit.s contains the basic bootstrap code that copies the decruncher to zeropage
# DecrZero.s is the decruncher
# ConvertToHeader takes the compiled DecrZeroInit.s and DecrZero.s and outputs DecrZero.h for the executable.
#     DecrZero.h now contains the binary decrunch blob and all the information needed to fill in all the values (where to copy from/to, what size the decruncher is, etc.)

CC			= gcc
CA			= ca65mega
LD			= ld65
XMEGA65		= H:\xemu\xmega65.exe

all: $(OBJECTS)
	ca65mega -g --cpu 45GS02 -U --feature force_range -o DecrZero.o DecrZero.s
	ld65 -C Linkfile.DecrZero -Ln DecrZero.symbols DecrZero.o -o DecrZero.prg

	ca65mega -g --cpu 45GS02 -U --feature force_range -o DecrZeroInit.o DecrZeroInit.s
	ld65 -C Linkfile.DecrZeroInit -Ln DecrZeroInit.symbols DecrZeroInit.o -o DecrZeroInit.prg

	gcc -O3 converttoheader.c -o converttoheader.exe
	./converttoheader.exe DecrZero.prg DecrZeroInit.prg DecrZero.symbols DecrZeroInit.symbols DecrZero.h
	gcc -O3 file.c cruncher.c megatool.c -o megatool.exe

run: all
	./megatool
	./megatool -a ./bin/boot.prg 00002100
	./megatool -c -e 00002100 ./bin/boot.prg.addr

	cmd.exe /c $(XMEGA65) -prg ./bin/boot.prg.addr.mc

#	./megatool -a ./bin/test.bin 00020000
#	./megatool -a ./bin/test2.bin 00010000
#	./megatool -a ./bin/test3.bin 00001400
#	./megatool -c ./bin/test.bin.addr > test.crunch.txt
#	./megatool -c ./bin/test2.bin.addr
#	./megatool -c ./bin/test3.bin.addr
#	./megatool -i ./bin/test.bin.addr.mc ./bin/test2.bin.addr.mc ./bin/alldata.bin
