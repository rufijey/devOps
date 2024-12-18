all: classa

classa: main.o ClassA.o
	g++ -g main.o ClassA.o -o classa.elf

main.o: main.cpp
	g++ -g -c main.cpp

ClassA.o: ClassA.cpp
	g++ -g -c ClassA.cpp

clean: 
	rm -rf -v *.o
	rm -rf -v *.gch


