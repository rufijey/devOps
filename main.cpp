#include <iostream>
#include "ClassA.h"

int main() {
	ClassA classA;
	std::cout << "FuncA result: " << classA.FuncA(5, 7.0) << std::endl;
	return 0;
}
