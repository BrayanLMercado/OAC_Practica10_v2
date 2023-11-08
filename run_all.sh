nasm -f elf p10.asm
ld -m elf_i386 -s -o p10 p10.o libpc_io.a
./p10
