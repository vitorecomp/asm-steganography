#!/bin/sh

nasm -f elf -F dwarf -g -o prog.o prog.asm
ld -m elf_i386 -o prog prog.o