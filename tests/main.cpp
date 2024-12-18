#include <iostream>
#include "../ClassA.h"

int main(int argc, char* argv[]) {
	ClassA classA;
	if (classA.FuncA(4, 3.0) == 40) {
		return 0;
	}
	
	return 1;

}
