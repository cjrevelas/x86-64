# Mafefile for main, circle and rectangle

main:	main.o	circle.o	rectangle.o
	gcc -g -no-pie -m64 -o main	main.o	circle.o rectangle.o

main.o:	main.s
	nasm -g -f elf64 -o main.o main.s

circle.o:	circle.s
	nasm -g -f elf64 -o circle.o circle.s

rectangle.o:	rectangle.s	
	nasm -g -f elf64 -o rectangle.o rectangle.s
