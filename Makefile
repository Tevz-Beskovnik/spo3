AS=nasm
LD=ld

all: build run

build:
	$(AS) -felf32 main.asm -o main.o
	$(LD) -m elf_i386 main.o /usr/lib/libc.so.6 -I/usr/lib/ld-linux.so.2 -o main

run: 
	@./main

clean:
	@rm -rf main
	@rm -rf main.o
	@rm -rf SysDir
